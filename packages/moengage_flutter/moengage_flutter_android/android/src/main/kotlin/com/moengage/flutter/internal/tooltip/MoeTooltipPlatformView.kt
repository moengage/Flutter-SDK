package com.moengage.flutter.internal.tooltip

import android.content.Context
import android.view.View
import com.moengage.flutter.KEY_TOOLTIP_MESSAGE
import io.flutter.plugin.platform.PlatformView

/**
 * Wraps a [TooltipBubbleView] as a `PlatformView` so it can be embedded directly in the Flutter
 * widget tree (positioned by Dart with `AndroidView` + `Positioned`), as an alternative to
 * [NativeTooltipRenderer]'s window-overlay rendering.
 */
internal class MoeTooltipPlatformView(
    context: Context,
    creationParams: Map<String?, Any?>?,
) : PlatformView {
    private val bubble =
        TooltipBubbleView(context, creationParams?.get(KEY_TOOLTIP_MESSAGE) as? String ?: "")

    override fun getView(): View = bubble

    override fun dispose() {}
}
