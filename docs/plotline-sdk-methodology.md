# Plotline Flutter SDK — Methodology

**Source:** `~/.pub-cache/hosted/pub.dev/plotline_engage-5.4.8/`

---

## Core Architecture

Plotline uses a **three-mode query system** driven by the native Plotline SDK over a `BasicMessageChannel`. Unlike Apxor (which dumps the entire widget tree), Plotline only exposes **explicitly tagged** widgets wrapped by the developer in a `PView` widget. This is the defining design decision.

```
Native Plotline SDK
      ↕ BasicMessageChannel ("plotlineMessageChannel")
Dart Layer (plotline.dart)
      ↕ VisibilityDetector on each PView
Widget Tree (only PView-wrapped nodes are trackable)
```

---

## 1. Widget Tagging — `PView`

Unlike Apxor's full tree walk, Plotline requires the developer to **explicitly opt widgets into tracking** using `PView`:

```dart
// plotline.dart:662
class PView extends StatelessWidget {
  final Widget child;
  final String valueKey;
  final bool isWidget;  // true = embedded card, false = tooltip anchor

  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(valueKey),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        String? referKey = Plotline.extractKeyValue(ValueKey(valueKey));
        Plotline.visibilityMap[referKey] = visiblePercentage;  // track live visibility
      },
      child: child,
    );
  }
}
```

Every `PView` continuously writes its **visible fraction (0–100%)** into `Plotline.visibilityMap`. This is the gating condition for all position queries — a widget is only returned if `visibilityMap[key] == 100.0` (fully on screen, nothing clipped or scrolled away).

**App developer usage:**
```dart
PView(
  valueKey: "checkout_button",
  child: ElevatedButton(onPressed: onCheckout, child: Text("Checkout")),
)
```

---

## 2. Three Query Commands (Native → Dart)

The native Plotline SDK sends commands via `BasicMessageChannel` (`plotlineMessageChannel`). Dart's `setMessageChannel()` handler (`plotline.dart:27`) dispatches to three functions:

### Command 1: `getAllElements` — Full Discovery Dump

```
Native → {"method":"getAllElements","listenerId":"42317","pixelRatio":3.0,"screenWidth":1080,"screenHeight":2400}
Dart  → recurseKey(_ctx, pixRatio, screenWidth, screenHeight)
      → returns only PView-wrapped elements with visibility == 100%
Dart  → plotlineChannel.invokeMethod('getAllElements', {"listenerId":"42317","elements":[...]})
Native → screenshotListenerMap["42317"].onPositionsReady(elements)
```

**`recurseKey()`** (`plotline.dart:266`) — visits all elements but only includes them if:
1. Widget key matches `"[<'...'>"` format (PView keys)
2. `visibilityMap[key] == 100.0`
3. Widget is within screen bounds

Position format:
```json
{
  "clientElementId": "checkout_button",
  "position": { "x": 96, "y": 2520, "width": 986, "height": 156 }
}
```
All values in **physical pixels** (`logical * pixelRatio + 0.6` rounding).

### Command 2: `areViewsPresent` — Presence Check

Used by the native SDK before showing a tooltip to verify the target widget is currently visible. The native SDK passes a list of `clientElementId`s; Dart returns which ones are present and fully visible.

```
Native → {"method":"areViewsPresent","listenerId":"73821","searchElements":[{"clientElementId":"checkout_button",...}],"pixelRatio":3.0,...}
Dart  → for each: checks visibilityMap[key] == 100.0 AND isWithinBounds()
Dart  → plotlineChannel.invokeMethod('areViewsPresent', {"listenerId":"73821","presentElements":[...]})
```

This is how Plotline implements **conditional tooltip display** — "only show the checkout tooltip if the checkout button is actually visible right now."

### Command 3: `getViewPosition` — Single Widget Position

Called immediately before rendering a tooltip to get the latest position of a specific widget. Used for live repositioning after scroll/layout change.

```
Native → {"method":"getViewPosition","listenerId":"91042","clientElementId":"checkout_button","pixelRatio":3.0,...}
Dart  → findViewByKey(key, _ctx) → RenderBox.localToGlobal(Offset.zero)
Dart  → plotlineChannel.invokeMethod('getViewPosition', {"listenerId":"91042","position":{"x":96,"y":2520,"width":986,"height":156}})
Native → viewsPositionListenerMap["91042"].onViewReady(ViewPosition(rect))
       → PlotlinePlugin.kt:451 → RectF(x, y, x+width, y+height)
```

On **not found or not visible**, Dart returns `{"x":-1,"y":-1,"width":-1,"height":-1}` (plotline.dart:511) — native SDK interprets negative values as "ignore / element not present."

---

## 3. Listener Map Pattern (Correlation ID)

All three query modes use a **random listener ID** to correlate async responses (PlotlinePlugin.kt:50):

```kotlin
val listenerId = generateRandomId()  // random 0–100000
screenshotListenerMap[listenerId] = callback
commandChannel?.send(obj)
// later, when Dart calls back with the same listenerId:
val callback = screenshotListenerMap.remove(listenerId)
callback?.onPositionsReady(elements)
```

This is functionally identical to Apxor's timestamp correlation (`"d_<timestamp>"`), just using random IDs instead of wall-clock time. The listener map is a simple `HashMap` without timeouts — if Flutter never responds, the callback leaks.

---

## 4. Scroll Tracking — `PlotlineWrapper`

Plotline wraps the app in a `NotificationListener` to detect scrolls:

```dart
// plotline.dart:604
class PlotlineWrapper extends StatefulWidget {
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification ||
            scrollNotification is ScrollUpdateNotification ||
            scrollNotification is ScrollEndNotification) {
          _handleScrollEvent();  // throttled to 250ms
        }
        return true;
      },
      child: widget.child,
    );
  }
  
  void _handleScrollEvent() {
    if (_allowScrollEvent) {
      Plotline.plotlineChannel.invokeMethod('notifyScroll');
      _allowScrollEvent = false;
      _throttleTimer = Timer(Duration(milliseconds: 250), () => _allowScrollEvent = true);
    }
  }
}
```

On each throttled scroll event, native Plotline SDK calls `getViewPosition` again to reposition any visible tooltip/spotlight to track the element as it scrolls.

---

## 5. Screenshot — Native-Side Capture

Unlike Apxor (which uses `RepaintBoundary.toImage()` on the Dart side), Plotline captures the screenshot **natively** via the Flutter engine renderer (PlotlinePlugin.kt:240):

```kotlin
PlotlineInternal.setScreenshotCallback(object : PlotlineScreenshotCallback {
    override fun onScreenshot(activity: Activity?, p1: PlotlineScreenshotBitmapCallback?) {
        var bitmap: Bitmap? = flutterEngine.renderer.bitmap  // direct GPU readback
        p1?.onBitmap(bitmap)
    }
})
```

`flutterEngine.renderer.bitmap` reads the current Flutter frame directly from the render thread — no Dart async round-trip needed. This is faster but may capture mid-frame renders.

---

## 6. Embedded Widget Cards — `PlotlineWidget`

For content widgets (banners, cards) embedded into the Flutter layout, Plotline uses the same `PlatformView` mechanism as Apxor:

```dart
// plotline_widget.dart:143
PView(
  valueKey: widget.valueKey,
  isWidget: true,  // marks as embedded widget, not tooltip anchor
  child: Offstage(
    offstage: !visible,
    child: SizedBox(
      width: width, height: height,
      child: AndroidView(viewType: 'so.plotline.plotline/FlutterPlotlineWidget', ...)
    )
  )
)
```

The native `PlotlineWidget` (`FlutterPlotlineWidget.kt`) renders the content, then calls back with rendered dimensions via `BasicMessageChannel("plotlineWidgetEvents_<testId>")`. Dart resizes the `SizedBox` to match.

Touch events (tap, pan, fling) are forwarded from Flutter → native via the same channel (`plotline.dart:257`), since `AndroidView` absorbs touches by default.

---

## 7. Marketer Workflow — How Widget Selection Works

This is the fundamental design question. Plotline's approach:

1. **Developer wraps targetable widgets** in `PView` with a `valueKey` they define.
2. **On `getAllElements`**, the native SDK gets the full list of currently visible `PView`-wrapped widgets with their positions + a screenshot.
3. **In Plotline Studio**, marketers see the screenshot with overlaid bounding boxes on each tagged widget. They click on a widget to select it as the tooltip anchor.
4. The selected widget's `valueKey` (e.g., `"checkout_button"`) is stored in the campaign config.
5. At runtime, the native SDK calls `areViewsPresent(["checkout_button"])` → if present, calls `getViewPosition("checkout_button")` → renders tooltip.

**Key implication**: Marketers can **only select widgets the developer explicitly tagged**. If a widget has no `PView`, it is invisible to the Plotline dashboard. This is by design — it prevents marketers from accidentally targeting internal implementation widgets.

---

## Comparison: Apxor vs Plotline

| Aspect | Apxor | Plotline |
|---|---|---|
| Widget discovery | Full tree walk, all Elements | Only `PView`-wrapped elements |
| Widget identity | `ValueKey<String>` on any widget | `PView.valueKey` (string passed to wrapper) |
| Visibility gate | `_isV()` checks `Visibility`/`Offstage`/`Opacity` | `VisibilityDetector` reports 0–100%, only shows at 100% |
| Query modes | `dump` (full) + `find` (single) | `getAllElements` + `areViewsPresent` + `getViewPosition` |
| Screenshot capture | Dart `RepaintBoundary.toImage()` | Native `flutterEngine.renderer.bitmap` |
| Scroll handling | Implicit — re-query on demand | `PlotlineWrapper` fires `notifyScroll` every 250ms |
| Correlation | Timestamp as ID | Random integer as listener ID |
| Timeout handling | 3s timeout in bridge | No timeout — leaks if Dart never responds |
| Embedded cards | `ApxorEmbedWidget` (identical pattern) | `PlotlineWidget` (identical pattern) |
| Dev work to integrate | Wrap app with `createWidget()`, add `ValueKey` to target widgets | Wrap app with `PlotlineWrapper`, wrap target widgets with `PView` |
