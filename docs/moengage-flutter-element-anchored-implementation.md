# MoEngage Flutter — Element-Anchored In-App Implementation

**References:**
- Apxor: `apxor-flutter-sdk/` — full tree dump, `RepaintBoundary` screenshot, timestamp correlation
- Plotline: `~/.pub-cache/hosted/pub.dev/plotline_engage-5.4.8/` — explicit tagging, visibility gate, native screenshot, `areViewsPresent` presence check
- MoEngage Android SDK: `../MoEngage-Android-SDK/inapp/`

---

## The Problem in One Sentence

Flutter renders everything onto a single native `SurfaceView`; Android has no idea where any Flutter widget is. MoEngage's nudges already overlay the `FlutterView` (added to `android.R.id.content`), but they cannot anchor to specific Flutter widgets because no native API exposes their coordinates.

---

## Design Decisions (Taking Best of Both)

| Decision | Choice | Reason |
|---|---|---|
| Widget exposure | **Explicit tagging** (Plotline approach) | Marketers should only see developer-approved widgets; prevents exposing internals |
| Tag mechanism | **`ValueKey<String>` on widget + `MoEWidget` wrapper** | `ValueKey` is idiomatic Flutter; `MoEWidget` adds visibility tracking without a third-party package |
| Screenshot | **Native via `flutterEngine.renderer.bitmap`** (Plotline approach) | No Dart async round-trip, no `RepaintBoundary` requirement, works even if dev forgets to wrap |
| Visibility gate | **Must be fully visible** (Plotline's 100% check) | Prevents tooltips pointing at off-screen or partially clipped elements |
| Query modes | **`areViewsPresent` + `getViewPosition`** (Plotline's split model) | Presence check is cheap; position fetch only happens when about to render |
| Scroll tracking | **Throttled `notifyScroll`** (Plotline approach) | Re-fetches position on scroll without polling |
| Correlation ID | **Timestamp** (Apxor approach) | Monotonically increasing, doubles as ordering/timeout key |
| Timeout | **3s with fallback** (Apxor + explicit) | Plotline leaks on no-response; MoEngage should always resolve |
| Fallback | **Configurable: BOTTOM or suppress** | Campaign can define what to do if element not found |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│  Flutter App (Dart)                                         │
│                                                             │
│  MaterialApp wrapped in MoEWidget (visibility tracker)      │
│                                                             │
│  Targetable widgets wrapped in MoEView("checkout_btn")      │
│    → reports visibility% to MoEFlutterInApp.visibilityMap   │
└────────────────┬────────────────────────────────────────────┘
                 │ BasicMessageChannel "moe_commands"
                 │ MethodChannel "moengage_flutter"
┌────────────────▼────────────────────────────────────────────┐
│  moengage_flutter_android (Flutter Plugin)                  │
│                                                             │
│  MoEFlutterBridge implements FlutterLayoutContract          │
│    - areViewsPresent(ids) → checks visibility + bounds      │
│    - getViewPosition(id)  → returns {x,y,w,h} in phys px   │
│    - captureScreenshot()  → flutterEngine.renderer.bitmap   │
└────────────────┬────────────────────────────────────────────┘
                 │ FlutterLayoutContract interface
┌────────────────▼────────────────────────────────────────────┐
│  MoEngage Android SDK — inapp module                        │
│                                                             │
│  ViewBuilder.buildAndShowInApp()                            │
│    → if flutterAnchorId set: call FlutterLayoutContract     │
│    → wait for bounds → AnchoredOverlayPositioner            │
│    → ViewHandler.addInAppToViewHierarchy()                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 1 — Dart Layer (Flutter SDK)

### 1.1 `MoEView` — Explicit Widget Tagging

Replaces `PView`. Wraps any widget to make it targetable by the MoEngage dashboard:

```dart
// lib/moe_view.dart
class MoEView extends StatefulWidget {
  final String id;       // marketer-visible element ID
  final Widget child;

  const MoEView({required this.id, required this.child, Key? key}) : super(key: key);

  @override
  State<MoEView> createState() => _MoEViewState();
}

class _MoEViewState extends State<MoEView> {
  double _visibleFraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<LayoutChangedNotification>(
      child: _VisibilityAwareWidget(
        id: widget.id,
        child: widget.child,
        onVisibilityChanged: (fraction) {
          _visibleFraction = fraction;
          MoEFlutterInApp._updateVisibility(widget.id, fraction);
        },
      ),
    );
  }
}
```

Simple implementation without third-party packages — use a `GlobalKey` + post-frame callback to measure the widget's visible rect relative to the screen:

```dart
// Visibility computed after each frame via WidgetsBinding.addPostFrameCallback
// Compares widget's global rect with the screen rect intersection.
// visibilityFraction = intersection.area / widget.area
```

**App developer usage:**
```dart
MoEView(
  id: "checkout_btn",
  child: ElevatedButton(
    key: const ValueKey("checkout_btn"),  // same string — both are required
    onPressed: onCheckout,
    child: const Text("Checkout"),
  ),
)
```

The `ValueKey` and `MoEView.id` use the same string. The `ValueKey` lets `localToGlobal()` find the `RenderBox`. The `MoEView` wrapper tracks live visibility.

### 1.2 `MoEFlutterInApp` — Command Handler

```dart
// lib/moe_flutter_inapp.dart
class MoEFlutterInApp {
  static const _commandChannel =
      BasicMessageChannel("moe_commands", JSONMessageCodec());
  static const _resultChannel =
      MethodChannel("moengage_flutter");

  static final Map<String, double> visibilityMap = {};  // elementId → visible%
  static final Map<String, BuildContext> _screenContexts = {};
  static String _currentScreen = "";

  static void _updateVisibility(String id, double fraction) {
    visibilityMap[id] = fraction;
  }

  static void init() {
    _commandChannel.setMessageHandler((message) async {
      final method = message["method"] as String;
      final listenerId = message["listenerId"] as String;
      final pixelRatio = (message["pixelRatio"] as num).toDouble();

      switch (method) {
        case "areViewsPresent":
          final ids = List<String>.from(message["elementIds"]);
          final present = _getVisibleElements(ids, pixelRatio);
          _resultChannel.invokeMethod("areViewsPresent", {
            "listenerId": listenerId,
            "presentElements": present,
          });
          break;

        case "getViewPosition":
          final id = message["elementId"] as String;
          final pos = _getPosition(id, pixelRatio);
          _resultChannel.invokeMethod("getViewPosition", {
            "listenerId": listenerId,
            "position": pos,  // {x,y,width,height} or all -1 if not found
          });
          break;
      }
    });
  }

  // Returns only fully visible elements (visibilityFraction == 1.0)
  static List<Map<String, dynamic>> _getVisibleElements(
      List<String> ids, double pixelRatio) {
    final result = <Map<String, dynamic>>[];
    for (final id in ids) {
      if ((visibilityMap[id] ?? 0) >= 1.0) {
        final pos = _getPosition(id, pixelRatio);
        if (pos["x"] != -1) result.add({"elementId": id, "position": pos});
      }
    }
    return result;
  }

  // Find widget by ValueKey, return physical pixel bounds
  static Map<String, int> _getPosition(String id, double pixelRatio) {
    final notFound = {"x": -1, "y": -1, "width": -1, "height": -1};
    final ctx = _screenContexts[_currentScreen];
    if (ctx == null || !ctx.mounted) return notFound;

    BuildContext? found;
    void search(Element element) {
      if (found != null) return;
      final key = element.widget.key;
      if (key is ValueKey<String> && key.value == id) {
        found = element;
        return;
      }
      element.visitChildElements(search);
    }

    try {
      (ctx as Element).visitChildElements(search);
    } catch (_) {
      return notFound;
    }

    if (found == null) return notFound;
    final renderBox = found!.findRenderObject();
    if (renderBox == null || renderBox is! RenderBox || !renderBox.hasSize) {
      return notFound;
    }

    // Use NavigatorState ancestor to handle nested navigators correctly (Apxor pattern)
    final navigator = found!.findAncestorStateOfType<NavigatorState>();
    final offset = navigator != null
        ? renderBox.localToGlobal(Offset.zero,
            ancestor: navigator.context.findRenderObject())
        : renderBox.localToGlobal(Offset.zero);

    return {
      "x":      (offset.dx * pixelRatio).round(),
      "y":      (offset.dy * pixelRatio).round(),
      "width":  (renderBox.size.width  * pixelRatio).round(),
      "height": (renderBox.size.height * pixelRatio).round(),
    };
  }

  static void trackScreen(String name, BuildContext context) {
    _screenContexts[name] = context;
    _currentScreen = name;
  }
}
```

### 1.3 `MoENavigationObserver` — Auto Screen Tracking

```dart
// lib/moe_observer.dart
class MoENavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    _track(route);
  }
  @override
  void didPop(Route route, Route? previousRoute) {
    _track(previousRoute);
  }
  void _track(Route? route) {
    if (route is PageRoute && route.navigator?.context != null) {
      final name = route.settings.name ?? '';
      if (name.isNotEmpty) {
        MoEFlutterInApp.trackScreen(name, route.navigator!.context);
      }
    }
  }
}
```

### 1.4 Scroll Tracking

Wrap the app body (not the root) to track scrolls:

```dart
// Add to PlotlineWrapper equivalent
NotificationListener<ScrollNotification>(
  onNotification: (n) {
    if (n is ScrollUpdateNotification) _throttledNotifyScroll();
    return false;  // don't consume — false allows scroll to propagate
  },
  child: child,
)

void _throttledNotifyScroll() {
  // Debounce 250ms, same as Plotline
  MoEFlutterInApp._resultChannel.invokeMethod("notifyScroll");
}
```

---

## Part 2 — Android Plugin (moengage_flutter_android)

### 2.1 `FlutterLayoutContract` — Interface in inapp Module

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/FlutterLayoutContract.kt
interface FlutterLayoutContract {
    /**
     * Check which of the given elementIds are currently visible in Flutter.
     * Callback fires on main thread with list of VisibleElement (id + bounds),
     * or empty list if Flutter unavailable.
     */
    fun areViewsPresent(
        elementIds: List<String>,
        onResult: (List<VisibleElement>) -> Unit
    )

    /**
     * Get fresh position for a single element. Used before rendering and on scroll.
     * Callback fires on main thread. Null = element not found/not visible.
     */
    fun getViewPosition(elementId: String, onResult: (WidgetBounds?) -> Unit)

    /**
     * Capture a screenshot of the Flutter view.
     * Used by the MoEngage dashboard "element picker" feature.
     */
    fun captureScreenshot(onResult: (Bitmap?) -> Unit)
}

data class VisibleElement(val elementId: String, val bounds: WidgetBounds)

data class WidgetBounds(val x: Int, val y: Int, val width: Int, val height: Int) {
    val right  get() = x + width
    val bottom get() = y + height
    val centerX get() = x + width / 2
    val centerY get() = y + height / 2
}
```

### 2.2 `MoEFlutterBridge` — Plugin Implementation

```kotlin
// moengage_flutter_android/MoEFlutterBridge.kt
class MoEFlutterBridge(
    private val binaryMessenger: BinaryMessenger,
    private val flutterEngine: FlutterEngine
) : FlutterLayoutContract, MethodChannel.MethodCallHandler {

    private val commandChannel = BasicMessageChannel(
        binaryMessenger, "moe_commands", JSONMessageCodec.INSTANCE)
    private val resultChannel = MethodChannel(
        binaryMessenger, "moengage_flutter")

    // Listener maps keyed by listenerId (timestamp string)
    private val presenceCallbacks =
        ConcurrentHashMap<String, (List<VisibleElement>) -> Unit>()
    private val positionCallbacks =
        ConcurrentHashMap<String, (WidgetBounds?) -> Unit>()

    init { resultChannel.setMethodCallHandler(this) }

    // ── FlutterLayoutContract ────────────────────────────────────────────────

    override fun areViewsPresent(
        elementIds: List<String>,
        onResult: (List<VisibleElement>) -> Unit
    ) {
        val listenerId = System.currentTimeMillis().toString()
        presenceCallbacks[listenerId] = onResult
        scheduleTimeout(listenerId, presenceCallbacks) { onResult(emptyList()) }

        mainThread {
            val obj = JSONObject().apply {
                put("method", "areViewsPresent")
                put("listenerId", listenerId)
                put("elementIds", JSONArray(elementIds))
                put("pixelRatio", density())
            }
            commandChannel.send(obj)
        }
    }

    override fun getViewPosition(elementId: String, onResult: (WidgetBounds?) -> Unit) {
        val listenerId = System.currentTimeMillis().toString()
        positionCallbacks[listenerId] = onResult
        scheduleTimeout(listenerId, positionCallbacks) { onResult(null) }

        mainThread {
            val obj = JSONObject().apply {
                put("method", "getViewPosition")
                put("listenerId", listenerId)
                put("elementId", elementId)
                put("pixelRatio", density())
            }
            commandChannel.send(obj)
        }
    }

    override fun captureScreenshot(onResult: (Bitmap?) -> Unit) {
        // Native-side capture — no Dart round-trip needed (Plotline approach)
        mainThread { onResult(flutterEngine.renderer.bitmap) }
    }

    // ── MethodChannel results from Dart ─────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "areViewsPresent" -> {
                val listenerId = call.argument<String>("listenerId") ?: return
                val callback = presenceCallbacks.remove(listenerId) ?: return
                val elements = call.argument<List<Map<String, Any>>>("presentElements")
                    ?.mapNotNull { it.toVisibleElement() } ?: emptyList()
                mainThread { callback(elements) }
                result.success(null)
            }
            "getViewPosition" -> {
                val listenerId = call.argument<String>("listenerId") ?: return
                val callback = positionCallbacks.remove(listenerId) ?: return
                val pos = call.argument<Map<String, Int>>("position")
                mainThread { callback(pos?.toWidgetBounds()) }
                result.success(null)
            }
            "notifyScroll" -> {
                // Re-fetch position for any currently visible anchored in-app
                InAppInstanceProvider.getAllInstances().forEach { sdkInstance ->
                    sdkInstance.inAppCache.visibleAnchoredCampaign?.let { (elementId, view, payload) ->
                        getViewPosition(elementId) { bounds ->
                            bounds?.let { view.updateAnchorPosition(it) }
                        }
                    }
                }
                result.success(null)
            }
        }
    }

    private fun <T> scheduleTimeout(
        listenerId: String,
        map: ConcurrentHashMap<String, T>,
        fallback: () -> Unit
    ) {
        Handler(Looper.getMainLooper()).postDelayed({
            if (map.remove(listenerId) != null) fallback()
        }, 3000L)
    }

    private fun density() = Resources.getSystem().displayMetrics.density
    private fun mainThread(block: () -> Unit) =
        Handler(Looper.getMainLooper()).post(block)
}

// Extension helpers
private fun Map<String, Any>.toVisibleElement(): VisibleElement? {
    val id = this["elementId"] as? String ?: return null
    val pos = this["position"] as? Map<*, *> ?: return null
    return VisibleElement(id, WidgetBounds(
        (pos["x"] as? Int) ?: return null,
        (pos["y"] as? Int) ?: return null,
        (pos["width"] as? Int) ?: return null,
        (pos["height"] as? Int) ?: return null,
    ))
}

private fun Map<String, Int>.toWidgetBounds(): WidgetBounds? {
    if ((this["x"] ?: -1) < 0) return null  // Plotline pattern: -1 = not found
    return WidgetBounds(this["x"]!!, this["y"]!!, this["width"]!!, this["height"]!!)
}
```

---

## Part 3 — Android SDK Changes (inapp module)

### 3.1 Campaign Payload Extension

```kotlin
// Add to CampaignPayload (or as a wrapper)
data class FlutterAnchor(
    val elementId: String,              // matches MoEView.id + ValueKey
    val fallback: InAppPosition = InAppPosition.BOTTOM,
    val arrowDirection: ArrowDirection = ArrowDirection.AUTO
)

// CampaignPayload gains:
val flutterAnchor: FlutterAnchor? = null
```

### 3.2 `ViewBuilder` — Pre-Show Position Resolution

In `ViewBuilder.buildAndShowInApp()`, intercept anchored campaigns before building the view:

```kotlin
fun buildAndShowInApp(
    context: Context,
    campaign: InAppCampaign,
    payload: CampaignPayload,
    triggerType: CampaignTriggerType
) {
    val anchor = payload.flutterAnchor
    if (anchor == null) {
        // Existing path — no change
        buildAndShow(context, campaign, payload, triggerType, anchorBounds = null)
        return
    }

    val contract = InAppInstanceProvider.getFlutterLayoutContract()
    if (contract == null) {
        // Flutter not integrated — use fallback position
        buildAndShow(context, campaign, payload.withFallbackPosition(anchor.fallback), triggerType, null)
        return
    }

    // Step 1: Check widget is present and visible
    contract.areViewsPresent(listOf(anchor.elementId)) { visibleElements ->
        if (visibleElements.isEmpty()) {
            // Widget not visible — suppress or show at fallback
            if (anchor.fallback != InAppPosition.SUPPRESS) {
                buildAndShow(context, campaign, payload.withFallbackPosition(anchor.fallback), triggerType, null)
            }
            return@areViewsPresent
        }

        // Step 2: Get precise position for rendering
        val bounds = visibleElements.first().bounds
        buildAndShow(context, campaign, payload, triggerType, anchorBounds = bounds)
    }
}
```

### 3.3 `AnchoredOverlayPositioner` — Layout Computation

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/engine/AnchoredOverlayPositioner.kt
internal object AnchoredOverlayPositioner {

    fun computeParams(
        anchor: WidgetBounds,
        overlayWidth: Int,
        overlayHeight: Int,
        screenWidth: Int,
        screenHeight: Int,
        direction: ArrowDirection
    ): AnchoredLayoutParams {

        val spaceBelow = screenHeight - anchor.bottom
        val spaceAbove = anchor.y

        val resolvedDirection = when (direction) {
            ArrowDirection.AUTO ->
                if (spaceBelow >= overlayHeight + ARROW_SIZE_PX) ArrowDirection.DOWN
                else ArrowDirection.UP
            else -> direction
        }

        val top = when (resolvedDirection) {
            ArrowDirection.DOWN -> anchor.bottom + ARROW_SIZE_PX
            ArrowDirection.UP   -> anchor.y - overlayHeight - ARROW_SIZE_PX
            else -> anchor.centerY - overlayHeight / 2
        }

        // Horizontally center on anchor, clamp to screen
        val left = (anchor.centerX - overlayWidth / 2)
            .coerceIn(SCREEN_MARGIN_PX, screenWidth - overlayWidth - SCREEN_MARGIN_PX)

        // Arrow points at center of anchor widget
        val arrowX = (anchor.centerX - left).coerceIn(ARROW_SIZE_PX, overlayWidth - ARROW_SIZE_PX)

        return AnchoredLayoutParams(
            topPx = top.coerceIn(0, screenHeight - overlayHeight),
            leftPx = left,
            arrowOffsetX = arrowX,
            direction = resolvedDirection
        )
    }

    private const val ARROW_SIZE_PX = 24
    private const val SCREEN_MARGIN_PX = 16
}

enum class ArrowDirection { AUTO, UP, DOWN, LEFT, RIGHT }
data class AnchoredLayoutParams(val topPx: Int, val leftPx: Int, val arrowOffsetX: Int, val direction: ArrowDirection)
```

### 3.4 Spotlight Overlay

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/views/MoESpotlightView.kt
class MoESpotlightView(context: Context) : View(context) {
    private val dimPaint   = Paint().apply { color = 0xCC000000.toInt() }
    private val clearPaint = Paint().apply {
        xfermode = PorterDuffXfermode(PorterDuff.Mode.CLEAR)
        isAntiAlias = true
    }
    var highlightBounds: RectF? = null
    var cornerRadius = 12f
    var padding = 8f

    override fun onDraw(canvas: Canvas) {
        val sc = canvas.saveLayer(null, null)
        canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), dimPaint)
        highlightBounds?.let { b ->
            canvas.drawRoundRect(
                RectF(b.left - padding, b.top - padding, b.right + padding, b.bottom + padding),
                cornerRadius, cornerRadius, clearPaint
            )
        }
        canvas.restoreToCount(sc)
    }

    // Call when scroll repositions the anchor
    fun updateAnchorPosition(bounds: WidgetBounds) {
        highlightBounds = RectF(
            bounds.x.toFloat(), bounds.y.toFloat(),
            bounds.right.toFloat(), bounds.bottom.toFloat()
        )
        invalidate()
    }
}
```

---

## Part 4 — Marketer Workflow (Dashboard "Element Picker")

This is what enables marketers to select Flutter widgets without knowing `ValueKey` strings.

### How It Works

1. **Developer ships the app** with `MoEView` wrappers on targetable widgets (same as `PView` in Plotline). Each widget gets a human-readable `id` like `"checkout_btn"`, `"promo_banner"`.

2. **MoEngage SDK debugger mode** (or a dedicated "preview" campaign type) triggers `getAllElements` on the current screen:
   ```kotlin
   // Native SDK requests full element list for dashboard display
   contract.areViewsPresent(allKnownIds) { visibleElements ->
       contract.captureScreenshot { bitmap ->
           // Send {screenshot, elements: [{id, bounds}]} to dashboard
       }
   }
   ```

3. **Dashboard shows** the screenshot with bounding boxes overlaid on each visible element. Marketer clicks on the "Checkout" button highlight → campaign gets `anchor_element_id: "checkout_btn"`.

4. **At campaign runtime**, `ViewBuilder` calls `areViewsPresent(["checkout_btn"])` → if present, `getViewPosition("checkout_btn")` → renders tooltip.

### Why Not Full Tree Dump (Apxor Approach)?

| | Full Tree Dump (Apxor) | Explicit Tags (Plotline/MoEngage) |
|---|---|---|
| Dev work | Just wrap app once | Wrap each targetable widget |
| Marketer experience | Sees every widget in the hierarchy | Only sees intentional targets |
| Risk | Marketers can target internal widgets | Controlled surface area |
| Payload size | Large JSON tree every query | Small list of tagged elements |
| Recommended for | Feature discovery tools | Campaign-driven engagement |

MoEngage's use case (marketers running campaigns) maps better to explicit tags. Developers know which elements should be targetable — they should make that choice, not the marketer.

---

## Part 5 — Complete Data Flow

```
Campaign arrives: { template: "tooltip", anchor_element_id: "checkout_btn", fallback: "BOTTOM" }
                              ↓
ViewBuilder.buildAndShowInApp() — detects flutterAnchor != null
                              ↓
FlutterLayoutContract.areViewsPresent(["checkout_btn"])
  → BasicMessageChannel "moe_commands":
    {"method":"areViewsPresent","listenerId":"1717000000000","elementIds":["checkout_btn"],"pixelRatio":3.0}
                              ↓
Dart: visibilityMap["checkout_btn"] == 1.0? YES
  → findViewByKey("checkout_btn") → RenderBox.localToGlobal() → physical px
  → MethodChannel "moengage_flutter":
    {"listenerId":"1717...","presentElements":[{"elementId":"checkout_btn","position":{"x":96,"y":840,"width":888,"height":52}}]}
                              ↓
MoEFlutterBridge.onMethodCall("areViewsPresent")
  → presenceCallbacks["1717..."]([VisibleElement("checkout_btn", WidgetBounds(96,840,888,52))])
                              ↓
FlutterLayoutContract.getViewPosition("checkout_btn")  ← fresh coords just before render
  → returns WidgetBounds(96, 840, 888, 52)
                              ↓
AnchoredOverlayPositioner.computeParams(anchor, overlayW, overlayH, screenW, screenH)
  → spaceBelow=1560 >= overlayHeight → direction=DOWN
  → topPx=892, leftPx=200, arrowOffsetX=244
                              ↓
ViewHandler.addInAppToViewHierarchy(activity, tooltipView, payload)
  → root.addView(tooltipView, FrameLayout.LayoutParams(leftMargin=200, topMargin=892))
  → Tooltip appears above FlutterSurfaceView, arrow at anchor.centerX
                              ↓
User scrolls → notifyScroll() → getViewPosition() → spotlight.updateAnchorPosition()
                              ↓
Screen change → handleDismiss() → root.removeView()
```

---

## Part 6 — App Developer Integration

```dart
// main.dart
void main() {
  MoEFlutterInApp.init();  // set up channel handlers
  runApp(
    MoEWrapper(  // scroll tracking wrapper (thin NotificationListener)
      child: const MyApp(),
    ),
  );
}

// MaterialApp
MaterialApp(
  navigatorObservers: [MoENavigationObserver()],  // auto screen tracking
  home: const HomeScreen(),
)

// Any screen — wrap targetable widgets
MoEView(
  id: "checkout_btn",
  child: ElevatedButton(
    key: const ValueKey("checkout_btn"),
    onPressed: onCheckout,
    child: const Text("Checkout"),
  ),
)

// Manual screen tracking (if not using observer)
@override
void initState() {
  super.initState();
  MoEFlutter.trackScreen("CartScreen", context);
}
```

**What developers do NOT need:**
- No `RepaintBoundary` wrapper (screenshot is taken natively)
- No app-level `GlobalKey`
- No platform channel boilerplate beyond the two wrappers above

---

## Part 7 — Edge Cases

| Case | Handling |
|---|---|
| Element not visible (scrolled off) | `visibilityMap[id] < 1.0` → `areViewsPresent` returns empty → fallback |
| Element not tagged (no `MoEView`) | `findViewByKey` returns null → `{x:-1}` → fallback |
| Nested Navigator (dialog/modal) | `findAncestorStateOfType<NavigatorState>()` as `localToGlobal` ancestor |
| Dart timeout (3s no response) | Timeout callback fires fallback |
| Screen rotation | `ConfigurationChangeHandler` re-runs `getViewPosition` on re-attach |
| Multiple Flutter engines | One `MoEFlutterBridge` registered per engine; campaigns carry `engineId` |
| Flutter not integrated (native-only) | `getFlutterLayoutContract()` returns null → existing nudge position logic runs unchanged |
| Tab switch | Tab change should call `trackScreen` → updates `_currentScreen` → next query uses correct context |
