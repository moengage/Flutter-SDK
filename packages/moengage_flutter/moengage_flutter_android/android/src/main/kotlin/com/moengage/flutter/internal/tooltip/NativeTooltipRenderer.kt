package com.moengage.flutter.internal.tooltip

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.annotation.VisibleForTesting
import androidx.lifecycle.findViewTreeLifecycleOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import com.moengage.flutter.internal.designmode.DesignModeElementBounds
import com.moengage.tooltip.BeaconPosition
import com.moengage.tooltip.MoEBeaconHelper
import com.moengage.tooltip.MoESpotlightHelper
import com.moengage.tooltip.MoETooltipHelper
import com.moengage.tooltip.SpotlightShape
import com.moengage.tooltip.TooltipPosition

/**
 * Which native `com.moengage:tooltip` overlay is currently showing, so [NativeTooltipRenderer.dismiss]
 * can call the matching helper's `dismiss()`.
 */
internal enum class TooltipOverlayType { TOOLTIP, BEACON, SPOTLIGHT }

/**
 * Bridges a resolved Flutter element (a [DesignModeElementBounds] reported by the Dart element
 * inspector) to the native `com.moengage:tooltip` SDK - [MoETooltipHelper], [MoEBeaconHelper] and
 * [MoESpotlightHelper] - which only accept a real Android [View] (or a `@IdRes`/tag reference) as
 * an anchor. Flutter widgets are painted onto a single Skia surface and have no native `View` of
 * their own, so an invisible, zero-size-safe marker `View` is added to the activity's content view
 * at the element's resolved screen bounds and passed as the anchor: the native SDK reads its
 * `getLocationOnScreen()`/size exactly as it would for any XML or Compose anchor.
 *
 * This is the `nativeOverlay` tooltip render mode - see [MoeTooltipPlatformView] for the
 * alternative Flutter-embedded `PlatformView` mode, which renders its own [TooltipBubbleView]
 * instead of going through this native SDK (that mode embeds the bubble inside the Flutter widget
 * tree, which the native SDK's window-overlay based rendering can't do).
 */
internal object NativeTooltipRenderer {
    private var anchorView: View? = null
    private var activeOverlay: TooltipOverlayType? = null

    /** Shows a native tooltip anchored just below/above [bounds], per [MoETooltipHelper]. */
    fun showTooltip(
        activity: Activity?,
        bounds: DesignModeElementBounds,
        position: TooltipPosition = TooltipPosition.AUTO,
    ) {
        val anchor = attachAnchor(activity, bounds) ?: return
        activeOverlay = TooltipOverlayType.TOOLTIP
        MoETooltipHelper.showTooltip(activity!!, anchor, position)
    }

    /** Shows a native pulsating beacon anchored to [bounds], per [MoEBeaconHelper]. */
    fun showBeacon(
        activity: Activity?,
        bounds: DesignModeElementBounds,
        position: BeaconPosition = BeaconPosition.TOP_END,
    ) {
        val anchor = attachAnchor(activity, bounds) ?: return
        activeOverlay = TooltipOverlayType.BEACON
        MoEBeaconHelper.showBeacon(activity!!, anchor, position)
    }

    /** Shows a native dimmed spotlight cutout around [bounds], per [MoESpotlightHelper]. */
    fun showSpotlight(
        activity: Activity?,
        bounds: DesignModeElementBounds,
        shape: SpotlightShape = SpotlightShape.CIRCLE,
    ) {
        val anchor = attachAnchor(activity, bounds) ?: return
        activeOverlay = TooltipOverlayType.SPOTLIGHT
        MoESpotlightHelper.showSpotlight(activity!!, anchor, shape)
    }

    /** Dismisses whichever overlay is currently showing, if any. Safe to call when none is. */
    fun dismiss() {
        when (activeOverlay) {
            TooltipOverlayType.TOOLTIP -> MoETooltipHelper.dismiss()
            TooltipOverlayType.BEACON -> MoEBeaconHelper.dismiss()
            TooltipOverlayType.SPOTLIGHT -> MoESpotlightHelper.dismiss()
            null -> {}
        }
        activeOverlay = null
        detachAnchor()
    }

    /**
     * Adds an invisible marker [View] to [activity]'s content view, sized and positioned to
     * exactly match [bounds] (physical pixels, screen-relative - the same coordinate space the
     * old window-overlay bubble used), and returns it for use as the native SDK's anchor `View`.
     */
    private fun attachAnchor(activity: Activity?, bounds: DesignModeElementBounds): View? {
        if (activity == null || activity.isFinishing || activity.isDestroyed) return null
        detachAnchor()
        ensureViewTreeLifecycleOwner(activity)

        val marker =
            View(activity).apply {
                alpha = 0f
                isClickable = false
                isFocusable = false
            }
        val params =
            FrameLayout.LayoutParams(
                (bounds.right - bounds.left).coerceAtLeast(1),
                (bounds.bottom - bounds.top).coerceAtLeast(1),
            ).apply {
                leftMargin = bounds.left
                topMargin = bounds.top
            }
        activity.window.addContentView(marker, params)
        anchorView = marker
        return marker
    }

    private fun detachAnchor() {
        anchorView?.let { view -> (view.parent as? ViewGroup)?.removeView(view) }
        anchorView = null
    }

    /**
     * The `com.moengage:tooltip` beacon/spotlight overlays add a Compose `ComposeView` directly
     * to [Activity.getWindow]'s decor view. Compose requires a [androidx.lifecycle.LifecycleOwner]
     * to be discoverable from that view via [ViewTreeLifecycleOwner], which `ComponentActivity`/
     * `AppCompatActivity` set up automatically - but Flutter's `FlutterActivity` extends the plain
     * `android.app.Activity` and never does, so without this the native SDK crashes with
     * `IllegalStateException: ViewTreeLifecycleOwner not found`.
     */
    private fun ensureViewTreeLifecycleOwner(activity: Activity) {
        val decorView = activity.window.decorView
        if (decorView.findViewTreeLifecycleOwner() != null) return
        val lifecycleOwner = activity as? androidx.lifecycle.LifecycleOwner ?: return
        decorView.setViewTreeLifecycleOwner(lifecycleOwner)
    }
}
