package com.moengage.flutter.internal.tooltip

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/** Factory for [MoeTooltipPlatformView], registered under the element-tooltip platform view type id. */
internal class MoeTooltipPlatformViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(
        context: Context,
        viewId: Int,
        args: Any?,
    ): PlatformView {
        @Suppress("UNCHECKED_CAST")
        val creationParams = args as? Map<String?, Any?>
        return MoeTooltipPlatformView(context, creationParams)
    }
}
