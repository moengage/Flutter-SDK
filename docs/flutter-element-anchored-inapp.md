# Flutter Element-Anchored In-App Overlays

**Reference implementation:** `apxor-flutter-sdk/` (cloned at project root)  
**MoEngage Android SDK:** `../MoEngage-Android-SDK/`  
**Date:** June 2026

---

## 1. The Problem

Flutter renders its entire UI onto a single native `SurfaceView` (`FlutterSurfaceView`). From Android's perspective every Flutter widget — buttons, text, images — is invisible. The native view hierarchy only knows about one big canvas. This means:

- MoEngage can already place in-apps **above** Flutter content (it adds views to `android.R.id.content` which is the parent of `FlutterView`), so full-screen modals and screen-edge nudges work today.
- What MoEngage **cannot** do today: anchor a tooltip, spotlight, or coach mark to a **specific Flutter widget** (e.g. "point arrow at the Checkout button"). No native API reveals where that button lives on screen.

---

## 2. How Apxor Solves It (Reference Implementation)

Apxor's solution: **make Flutter report its own widget positions in physical pixels**, then let native draw above the Flutter canvas at those exact coordinates.

### 2.1 Data Model — The Layout Tree

Apxor serializes every Flutter widget into a JSON tree (`LT` class, `apxor_flutter.dart:727`):

```json
{
  "id": "checkout_button",
  "path": "/[0]/Scaffold/[1]/Column/[2]/ElevatedButton",
  "view": "ElevatedButton",
  "bounds": { "top": 840, "left": 32, "bottom": 892, "right": 718 },
  "views": [...],
  "additional_info": {
    "content": "Checkout",
    "parent_type": "Column",
    "closest_parent_id": "cart_section",
    "sdk_variant": "flutter"
  }
}
```

All bounds are in **physical pixels** (logical px × `devicePixelRatio`).

### 2.2 Widget Position Extraction

`_v()` function (`apxor_flutter.dart:522`) walks every mounted `Element`:

```dart
RenderBox b = e?.findRenderObject() as RenderBox;
final s = e?.findAncestorStateOfType<NavigatorState>();
if (s != null) {
  // Anchor to Navigator to handle modals and nested navigators correctly
  o = b.localToGlobal(Offset.zero, ancestor: s.context.findRenderObject());
} else {
  o = b.localToGlobal(Offset.zero);
}
ltn.po = Rect.fromLTRB(o.dx, o.dy, o.dx + b.size.width, o.dy + b.size.height);
```

- `findRenderObject()` returns the element's `RenderBox`
- `localToGlobal(Offset.zero)` walks the render tree upward, accumulating all transforms and scroll offsets, giving the widget's origin in screen-space **logical pixels**
- Multiplied by `devicePixelRatio` → physical pixels that match Android's coordinate system exactly

Widget identity comes from `ValueKey<String>` (`apxor_flutter.dart:467`). Without a key, a structural path like `/[0]/Scaffold/[2]/ElevatedButton` is generated.

### 2.3 Screenshot Capture

A `RepaintBoundary` wraps the entire app (`apxor_widget.dart:14`) via `ApxorFlutter.createWidget()`. On demand:

```dart
RenderRepaintBoundary boundary = captureKey.currentContext?.findRenderObject();
ui.Image image = await boundary.toImage(pixelRatio: devicePixelRatio);
ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
// → base64 PNG sent alongside layout tree
```

This gives the native SDK a visual snapshot to use in the Apxor Studio dashboard.

### 2.4 Channel Protocol

Two Flutter platform channels bridge Dart ↔ Android:

| Channel | Type | Direction | Purpose |
|---|---|---|---|
| `plugins.flutter.io/apxor_commands` | `BasicMessageChannel` (JSON) | Native → Dart | Commands: `d` (dump), `f` (find), `avf` (all views) |
| `plugins.flutter.io/apxor_flutter` | `MethodChannel` | Dart → Native | Responses: `dr` (dump result), `fr` (find result), `avf` (all views result) |

**Dump flow (`"d"` command):**

```
Native RTM SDK fires "d" event
  → ApxorFlutterPlugin.onEvent() (ApxorFlutterPlugin.java:208)
  → BasicMessageChannel.send({"name":"d", "d": pixelRatio, "t": timestamp})
  → Dart _init() handler receives it (apxor_flutter.dart:103)
  → _d1(pixelRatio) → _g() → _v() traverses widget tree
  → Captures screenshot via RepaintBoundary
  → apxorMethodChannel.invokeMethod("dr", {"r": layoutTree, "t": timestamp})
  → Java handleES() dispatches Event("d_<timestamp>", layoutTree)
  → RTM SDK picks up "d_<timestamp>", now has all widget bounds + screenshot
```

**Find flow (`"f"` command)** — used during live display to re-query bounds after scroll/resize:

```
Native RTM SDK fires "f" with widget path
  → Flutter findView(layout, path) searches by id/path/op
  → Returns {"t": top, "l": left, "b": bottom, "r": right} in physical px
  → Native re-positions overlay to match fresh bounds
```

### 2.5 Native Overlay Rendering

The `UIManager` from `apxor-android-sdk-rtm.aar` receives the physical pixel bounds and renders a native `View` (tooltip bubble, spotlight ring, coach mark) above the `FlutterView` using Android's `WindowManager` or `ViewOverlay`. The arrow direction, pointer anchor point, and highlight ring are all computed from the `{top, left, bottom, right}` rect.

On screen transition, `UIManager.removeMessage()` is called (`ApxorFlutterPlugin.java:423`).

### 2.6 Why Physical Pixel Coordinates Work

Flutter's `FlutterSurfaceView` fills the entire Activity window. Flutter uses **logical pixels** internally but `localToGlobal()` returns logical pixel offsets from the top-left of the `FlutterSurfaceView`. Since `FlutterSurfaceView` is at `(0, 0)` in the Android window, multiplying by `devicePixelRatio` gives exact Android physical pixel coordinates. No additional offset correction is needed.

---

## 3. MoEngage Current In-App Architecture

### 3.1 How Views Are Added to the Screen

`ViewHandler.addInAppToViewHierarchy()` (`ViewHandler.kt:getWindowRoot`):

```kotlin
val root = activity.window.decorView
    .findViewById<View>(android.R.id.content).rootView as FrameLayout
root.addView(view)  // InAppModuleManager.addInAppToViewHierarchy()
```

`android.R.id.content` is the `FrameLayout` that Android creates as the content container of every Activity. The `FlutterView` lives inside this FrameLayout. MoEngage's in-app view is added as a **sibling** on top — so in-app content already renders above Flutter content. This is why full-screen modals and screen-edge nudges work today in Flutter with zero extra code.

### 3.2 Current Nudge Position System

`InAppPosition` enum (`InAppPosition.kt`):

```kotlin
enum class InAppPosition { ANY, TOP, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT }
```

`HtmlNudgeViewEngine.transformMarginForInAppPosition()` accounts for status bar and navigation bar insets and uses `FrameLayout.LayoutParams.gravity` to position nudges at screen edges. This is **screen-level positioning** — no widget awareness.

### 3.3 What Works Today in Flutter

| In-App Type | Works in Flutter? | Reason |
|---|---|---|
| Full-screen modal (HTML/Native) | ✅ Yes | Drawn above `FlutterView` |
| Screen-edge nudge (TOP/BOTTOM) | ✅ Yes | Gravity-based, no widget needed |
| Self-handled (app renders itself) | ✅ Yes | Dart/Flutter renders it |
| Element-anchored tooltip | ❌ No | Needs widget coordinates |
| Spotlight over specific widget | ❌ No | Needs widget bounds |
| Coach mark pointing at element | ❌ No | Needs widget bounds |

---

## 4. How MoEngage Can Implement Element-Anchored Overlays

### 4.1 Required Changes Overview

```
Flutter SDK (moengage_flutter_android)    Android SDK (inapp module)
─────────────────────────────────────     ──────────────────────────────
1. MoEFlutterBridge.kt                    1. FlutterLayoutContract (interface)
   - BasicMessageChannel listener         2. InAppController.kt
   - Dump widget tree on command             - call FlutterLayoutContract.requestLayout()
   - Return JSON + screenshot                - await callback with bounds
2. Widget tree extractor (Dart)           3. InAppBuilder.kt / ViewHandler.kt
   - Same logic as Apxor's _v()/_g()         - If campaign has flutter_anchor_id:
   - Reads ValueKey + localToGlobal()           → request layout dump first
3. MoEWidget wrapper (Dart)                   → compute overlay position
   - RepaintBoundary for screenshots        4. New AnchoredInAppPayload model
4. Platform channel contract                  - anchorId: String
   - "moe_commands" BasicMessageChannel     5. New InAppPosition.FLUTTER_ANCHOR
   - "moe_flutter" MethodChannel
```

### 4.2 Platform Channel Contract

Define two channels in the Flutter Android plugin (`moengage_flutter_android`):

```kotlin
// MoEFlutterBridge.kt
val commandChannel = BasicMessageChannel(
    binaryMessenger,
    "plugins.flutter.io/moe_commands",
    JSONMessageCodec.INSTANCE
)
val resultChannel = MethodChannel(
    binaryMessenger,
    "plugins.flutter.io/moe_flutter"
)
```

**Commands sent from Android → Dart:**

| Command `name` | Payload | Purpose |
|---|---|---|
| `"dump"` | `{"d": pixelRatio, "t": timestamp}` | Full widget tree + screenshot |
| `"find"` | `{"id": "widget_key", "t": timestamp}` | Single widget bounds refresh |

**Results sent from Dart → Android via MethodChannel:**

| Method | Args | Purpose |
|---|---|---|
| `"dump_result"` | `{"r": layoutTree, "t": timestamp}` | Full tree response |
| `"find_result"` | `{"r": {"t":top,"l":left,"b":bottom,"r":right}, "t": timestamp}` | Single widget bounds |

The `timestamp` field creates a unique correlation ID so the Android SDK can match async responses to their requests without a synchronous lock.

### 4.3 Dart Layer Changes (Flutter SDK)

**Add to `moengage_flutter_android` or a new `moengage_flutter_inapp` package:**

```dart
class MoEFlutterInApp {
  static const _commandChannel = BasicMessageChannel(
    "plugins.flutter.io/moe_commands", JSONMessageCodec());
  static const _resultChannel = MethodChannel("plugins.flutter.io/moe_flutter");

  static bool _initialized = false;
  static final _captureKey = GlobalKey();
  static final Map<String, BuildContext> _screenContexts = {};
  static String _currentScreen = "";

  static Widget wrapApp(Widget child) {
    return RepaintBoundary(key: _captureKey, child: child);
  }

  static void _init() {
    _commandChannel.setMessageHandler((message) async {
      final name = message["name"] as String;
      final timestamp = message["t"] as int;
      final pixelRatio = (message["d"] as num?)?.toDouble() ?? 1.0;

      if (name == "dump") {
        final result = await _dumpLayout(pixelRatio);
        _resultChannel.invokeMethod("dump_result", {"r": result, "t": timestamp});
      } else if (name == "find") {
        final widgetId = message["id"] as String;
        final bounds = await _findWidget(widgetId, pixelRatio);
        _resultChannel.invokeMethod("find_result", {"r": bounds, "t": timestamp});
      }
    });
    _initialized = true;
  }

  static Future<Map<String, dynamic>> _dumpLayout(double pixelRatio) async {
    final tree = await _extractLayoutTree(pixelRatio);
    final screenshot = await _captureScreenshot(pixelRatio);
    return {"layout": tree, "screenshot": screenshot};
  }

  static Future<Map<String, dynamic>?> _findWidget(
      String widgetId, double pixelRatio) async {
    final tree = await _extractLayoutTree(pixelRatio);
    final node = _findInTree(tree, widgetId);
    if (node == null) return {"t": 0, "l": 0, "b": 0, "r": 0};
    return node["bounds"];
  }
}
```

**Widget tree extraction** — exact same logic as Apxor's `_v()`:

```dart
static Future<List<Map<String, dynamic>>> _extractLayoutTree(double pixelRatio) async {
  final results = <Map<String, dynamic>>[];
  final rootElement = _getCurrentRootElement();
  if (rootElement == null) return results;

  void visit(Element element, List<Map<String, dynamic>> children) {
    final renderObject = element.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;
    if (!renderObject.hasSize) return;

    final navigator = element.findAncestorStateOfType<NavigatorState>();
    final offset = navigator != null
        ? renderObject.localToGlobal(Offset.zero,
            ancestor: navigator.context.findRenderObject())
        : renderObject.localToGlobal(Offset.zero);

    final node = <String, dynamic>{
      "id": _extractKey(element),
      "type": element.widget.runtimeType.toString(),
      "bounds": {
        "top":    (offset.dy * pixelRatio).toInt(),
        "left":   (offset.dx * pixelRatio).toInt(),
        "bottom": ((offset.dy + renderObject.size.height) * pixelRatio).toInt(),
        "right":  ((offset.dx + renderObject.size.width) * pixelRatio).toInt(),
      },
      "children": <Map<String, dynamic>>[],
    };

    children.add(node);
    element.visitChildElements((child) {
      if (child.mounted) visit(child, node["children"]);
    });
  }

  rootElement.visitChildElements((e) => visit(e, results));
  return results;
}

static String? _extractKey(Element element) {
  final key = element.widget.key;
  if (key is ValueKey<String>) return key.value;
  return null;
}
```

**Widget tagging convention for MoEngage:**

```dart
// App developer tags a widget for MoEngage targeting:
ElevatedButton(
  key: const ValueKey("moe_checkout_btn"),
  onPressed: onCheckout,
  child: const Text("Checkout"),
)
```

The `"moe_"` prefix is a recommended convention but not enforced — any `ValueKey<String>` works.

### 4.4 Android SDK Changes

#### 4.4.1 New Payload Model

Add `anchorId` to the in-app campaign payload:

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/model/AnchoredCampaignPayload.kt
internal data class FlutterAnchorMeta(
    val anchorId: String,           // matches ValueKey in Flutter
    val offsetDp: PointF = PointF() // optional fine-tune offset in dp
)

// Add to CampaignPayload:
internal val flutterAnchor: FlutterAnchorMeta? = null
```

Add `InAppPosition.FLUTTER_ANCHOR` to the existing enum, or use a separate flag on the payload:

```kotlin
// InAppPosition.kt
enum class InAppPosition {
    ANY, TOP, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT,
    FLUTTER_ANCHOR  // new — position relative to a specific Flutter widget
}
```

#### 4.4.2 FlutterLayoutContract Interface

Place in the `inapp` module so it can be implemented by the Flutter bridge:

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/FlutterLayoutContract.kt
interface FlutterLayoutContract {
    /**
     * Request a full layout dump from Flutter.
     * [onResult] is called on the main thread with widget bounds map keyed by widget ID,
     * or null if Flutter is unavailable.
     */
    fun requestLayoutDump(pixelRatio: Float, onResult: (LayoutDumpResult?) -> Unit)

    /**
     * Request fresh bounds for a single widget by its ValueKey ID.
     * Used to reposition an overlay after scroll/resize.
     */
    fun requestWidgetBounds(widgetId: String, pixelRatio: Float, onResult: (WidgetBounds?) -> Unit)
}

data class LayoutDumpResult(
    val widgets: Map<String, WidgetBounds>,  // keyed by ValueKey ID
    val screenshotBase64: String?
)

data class WidgetBounds(
    val top: Int, val left: Int, val bottom: Int, val right: Int  // physical px
) {
    val width get() = right - left
    val height get() = bottom - top
    val centerX get() = left + width / 2
    val centerY get() = top + height / 2
}
```

Register from the Flutter plugin:

```kotlin
// moengage_flutter_android: MoEFlutterPlugin.kt
class MoEFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val bridge = MoEFlutterBridge(binding.binaryMessenger)
        InAppInstanceProvider.setFlutterLayoutContract(bridge)
    }
}
```

#### 4.4.3 MoEFlutterBridge (Flutter Plugin Side)

```kotlin
// moengage_flutter_android: MoEFlutterBridge.kt
class MoEFlutterBridge(messenger: BinaryMessenger) :
    FlutterLayoutContract, MethodChannel.MethodCallHandler {

    private val commandChannel = BasicMessageChannel(
        messenger, "plugins.flutter.io/moe_commands", JSONMessageCodec.INSTANCE)
    private val resultChannel = MethodChannel(
        messenger, "plugins.flutter.io/moe_flutter")

    private val pendingDumps = ConcurrentHashMap<Long, (LayoutDumpResult?) -> Unit>()
    private val pendingFinds = ConcurrentHashMap<Long, (WidgetBounds?) -> Unit>()

    init {
        resultChannel.setMethodCallHandler(this)
    }

    override fun requestLayoutDump(pixelRatio: Float, onResult: (LayoutDumpResult?) -> Unit) {
        val timestamp = System.currentTimeMillis()
        pendingDumps[timestamp] = onResult
        Handler(Looper.getMainLooper()).post {
            commandChannel.send(mapOf("name" to "dump", "d" to pixelRatio, "t" to timestamp))
        }
        // Timeout: if Flutter doesn't respond in 3s, cancel
        Handler(Looper.getMainLooper()).postDelayed({
            pendingDumps.remove(timestamp)?.invoke(null)
        }, 3000)
    }

    override fun requestWidgetBounds(
        widgetId: String, pixelRatio: Float, onResult: (WidgetBounds?) -> Unit) {
        val timestamp = System.currentTimeMillis()
        pendingFinds[timestamp] = onResult
        Handler(Looper.getMainLooper()).post {
            commandChannel.send(mapOf(
                "name" to "find", "id" to widgetId, "d" to pixelRatio, "t" to timestamp))
        }
        Handler(Looper.getMainLooper()).postDelayed({
            pendingFinds.remove(timestamp)?.invoke(null)
        }, 2000)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val timestamp = call.argument<Long>("t") ?: return
        when (call.method) {
            "dump_result" -> {
                val callback = pendingDumps.remove(timestamp) ?: return
                val rawResult = call.argument<Map<String, Any>>("r")
                callback(rawResult?.toDumpResult())
                result.success(null)
            }
            "find_result" -> {
                val callback = pendingFinds.remove(timestamp) ?: return
                val boundsMap = call.argument<Map<String, Int>>("r")
                callback(boundsMap?.toWidgetBounds())
                result.success(null)
            }
        }
    }
}
```

#### 4.4.4 InAppController Changes

In `ViewBuilder.buildAndShowInApp()` (or a new pre-show step), intercept campaigns with a Flutter anchor:

```kotlin
// ViewBuilder.kt - add before controller.viewHandler.buildAndShowInApp()
private fun resolveFlutterAnchorIfNeeded(
    payload: CampaignPayload,
    onReady: (WidgetBounds?) -> Unit
) {
    val anchor = payload.flutterAnchor
    if (anchor == null) {
        onReady(null)
        return
    }
    val pixelRatio = context.resources.displayMetrics.density
    InAppInstanceProvider.getFlutterLayoutContract()?.requestWidgetBounds(
        anchor.anchorId, pixelRatio
    ) { bounds -> onReady(bounds) } ?: onReady(null)
}
```

#### 4.4.5 Overlay Positioning Engine

Once widget bounds are known, position the overlay relative to the anchor rect:

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/engine/AnchoredOverlayPositioner.kt
internal object AnchoredOverlayPositioner {

    fun computeLayoutParams(
        anchor: WidgetBounds,
        overlayWidth: Int,
        overlayHeight: Int,
        screenWidth: Int,
        screenHeight: Int,
        preferredDirection: ArrowDirection = ArrowDirection.AUTO
    ): AnchoredLayoutParams {
        val spaceAbove = anchor.top
        val spaceBelow = screenHeight - anchor.bottom

        val direction = when (preferredDirection) {
            ArrowDirection.AUTO -> if (spaceBelow >= overlayHeight) ArrowDirection.UP else ArrowDirection.DOWN
            else -> preferredDirection
        }

        val top = when (direction) {
            ArrowDirection.UP   -> anchor.bottom  // tooltip appears below the widget
            ArrowDirection.DOWN -> anchor.top - overlayHeight  // above
            else -> anchor.centerY - overlayHeight / 2
        }

        // Horizontally center on the anchor, clamp to screen edges
        val left = (anchor.centerX - overlayWidth / 2)
            .coerceIn(0, screenWidth - overlayWidth)

        val arrowOffsetX = anchor.centerX - left  // arrow points at widget center

        return AnchoredLayoutParams(
            topPx = top,
            leftPx = left,
            arrowOffsetX = arrowOffsetX,
            direction = direction
        )
    }
}

enum class ArrowDirection { AUTO, UP, DOWN, LEFT, RIGHT }

data class AnchoredLayoutParams(
    val topPx: Int,
    val leftPx: Int,
    val arrowOffsetX: Int,
    val direction: ArrowDirection
)
```

Apply to the view:

```kotlin
// In ViewHandler.addInAppToViewHierarchy(), after getting root FrameLayout:
val lp = FrameLayout.LayoutParams(
    ViewGroup.LayoutParams.WRAP_CONTENT,
    ViewGroup.LayoutParams.WRAP_CONTENT
)
lp.leftMargin = anchoredParams.leftPx
lp.topMargin  = anchoredParams.topPx
view.layoutParams = lp
root.addView(view)
```

---

## 5. Spotlight / Focus-Highlight Implementation

A spotlight (dimmed background with a highlight cut-out over the target widget) needs the anchor bounds to draw the transparent hole.

### 5.1 SpotlightOverlayView

```kotlin
// inapp/src/main/java/com/moengage/inapp/internal/views/SpotlightOverlayView.kt
class SpotlightOverlayView(context: Context) : View(context) {

    private val overlayPaint = Paint().apply {
        color = Color.parseColor("#CC000000")  // semi-transparent black
    }
    private val eraserPaint = Paint().apply {
        xfermode = PorterDuffXfermode(PorterDuff.Mode.CLEAR)
        isAntiAlias = true
    }

    var highlightRect: RectF? = null
    var cornerRadiusPx: Float = 12f
    var paddingPx: Float = 8f

    override fun onDraw(canvas: Canvas) {
        val sc = canvas.saveLayer(0f, 0f, width.toFloat(), height.toFloat(), null)
        canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), overlayPaint)
        highlightRect?.let { rect ->
            val padded = RectF(
                rect.left - paddingPx, rect.top - paddingPx,
                rect.right + paddingPx, rect.bottom + paddingPx
            )
            canvas.drawRoundRect(padded, cornerRadiusPx, cornerRadiusPx, eraserPaint)
        }
        canvas.restoreToCount(sc)
    }
}
```

Usage in `ViewHandler`:

```kotlin
val spotlight = SpotlightOverlayView(activity)
spotlight.setLayerType(View.LAYER_TYPE_HARDWARE, null)  // required for PorterDuff CLEAR
spotlight.highlightRect = RectF(
    anchor.left.toFloat(), anchor.top.toFloat(),
    anchor.right.toFloat(), anchor.bottom.toFloat()
)
val lp = FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT)
root.addView(spotlight, lp)
```

---

## 6. Complete Data Flow (MoEngage Proposed)

```
Campaign payload arrives with { flutter_anchor_id: "moe_checkout_btn" }
             ↓
ViewBuilder.buildAndShowInApp() detects flutterAnchor != null
             ↓
FlutterLayoutContract.requestWidgetBounds("moe_checkout_btn", pixelRatio) called
             ↓
MoEFlutterBridge sends BasicMessageChannel: {"name":"find","id":"moe_checkout_btn","t":1717...}
             ↓
Dart MoEFlutterInApp._commandChannel handler receives "find"
  → _extractLayoutTree() → RenderBox.localToGlobal() for every Element
  → _findInTree(tree, "moe_checkout_btn") → finds matching ValueKey
  → Returns {"t":840,"l":32,"b":892,"r":718} in physical px
             ↓
MethodChannel "find_result" → MoEFlutterBridge.onMethodCall()
  → pendingFinds[timestamp] callback invoked with WidgetBounds(top=840, left=32, ...)
             ↓
AnchoredOverlayPositioner.computeLayoutParams(anchor, overlayWidth, ...)
  → topPx=892, leftPx=200, arrowOffsetX=183, direction=UP
             ↓
ViewHandler.addInAppToViewHierarchy(activity, tooltipView, payload)
  → root.addView(tooltipView) with FrameLayout.LayoutParams(leftMargin=200, topMargin=892)
             ↓
Tooltip appears above FlutterView at exact widget position
             ↓
Screen change → handleDismiss() → root.removeView()
```

---

## 7. Key Differences vs Apxor

| Aspect | Apxor | MoEngage (proposed) |
|---|---|---|
| Layout request trigger | Native RTM SDK fires internal event | `InAppController` requests before showing anchored campaign |
| Full dump vs single find | Both — dump for discovery, find for live reposition | Start with find-only; add dump if dashboard preview is needed |
| Screenshot | Yes — sent with dump for Apxor Studio | Optional — only needed if MoEngage dashboard needs live preview |
| Widget ID convention | Any `ValueKey<String>` | Recommended prefix `"moe_"` but any `ValueKey<String>` |
| Channel architecture | `BasicMessageChannel` (JSON) + `MethodChannel` | Same — reuse existing `moengage_flutter` MethodChannel, add new command channel |
| Existing Flutter bridge | Separate `apxor_flutter` plugin | Add to existing `moengage_flutter_android` package |
| Overlay rendering | Native `UIManager` from closed-source `apxor-android-sdk-rtm.aar` | Open — implement `AnchoredOverlayPositioner` + `SpotlightOverlayView` in `inapp` module |
| Screen cleanup | `UIManager.removeMessage()` on every `trackScreen` | `ViewHandler.handleDismiss()` already called on every screen change — reuse |
| Fallback if widget not found | Show nothing | Show at `BOTTOM` position as fallback (configurable) |

---

## 8. App Developer Integration

### Dart side (app code)

```dart
// main.dart — wrap the app
void main() {
  runApp(MoEFlutterInApp.wrapApp(const MyApp()));
}

// screens — tag targetable widgets
ElevatedButton(
  key: const ValueKey("moe_checkout_btn"),
  onPressed: onCheckout,
  child: const Text("Checkout"),
)

// Optional — track screen so MoEngage knows which BuildContext to use
@override
void initState() {
  super.initState();
  MoEFlutter.trackScreen("CartScreen", context);
}
```

### MoEngage Dashboard (campaign config)

```json
{
  "template_type": "tooltip",
  "position": "FLUTTER_ANCHOR",
  "flutter_anchor_id": "moe_checkout_btn",
  "arrow_direction": "auto",
  "fallback_position": "BOTTOM"
}
```

---

## 9. Edge Cases to Handle

| Case | Handling |
|---|---|
| Widget not found (wrong key / not mounted) | Return `{0,0,0,0}` → fall back to `fallback_position` |
| Widget off-screen (inside a scrolled ListView) | `localToGlobal()` returns negative top → treat as not visible |
| Nested Navigator (modal/bottom sheet) | `findAncestorStateOfType<NavigatorState>()` as `ancestor` — same fix as Apxor |
| Screen rotation during display | Re-request bounds on config change; `ConfigurationChangeHandler` already calls `dismissOnConfigurationChange()` then re-shows |
| Flutter not initialized (native-only app using MoEngage) | `FlutterLayoutContract` is null → `resolveFlutterAnchorIfNeeded()` calls `onReady(null)` → fallback position |
| Multiple Flutter engines | Register one `FlutterLayoutContract` per engine; campaigns carry an engine ID |
| Tab change | `ViewBuilder.showNudgeInApp()` is already called per screen; tab changes should call `trackScreen()` |