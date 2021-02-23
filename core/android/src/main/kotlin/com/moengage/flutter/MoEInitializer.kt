package com.moengage.flutter

import android.content.Context
import com.moengage.core.MoEngage
import com.moengage.core.internal.logger.Logger
import com.moengage.core.internal.model.IntegrationMeta
import com.moengage.flutter.BuildConfig.MOENGAGE_FLUTTER_LIBRARY_VERSION
import com.moengage.plugin.base.PluginInitializer.initialize

/**
 * @author Umang Chamaria
 * Date: 2019-12-03
 */
class MoEInitializer {
    companion object {
        private const val tag: String = "${MODULE_TAG}MoEInitializer"

        @JvmStatic
        fun initialize(context: Context, builder: MoEngage.Builder) {
            try {
                Logger.v("$tag initialize() : Will try to initialize the sdk.")
                initialize(
                    context,
                    builder,
                    true
                )
            } catch (e: Exception) {
                Logger.e("$tag initialize() : Exception: ", e)
            }
        }

        @JvmStatic
        fun initialize(context: Context, builder: MoEngage.Builder, isSdkEnabled: Boolean) {
            try {
                Logger.v("$tag initialize() : Will try to initialize the sdk.")
                initialize(
                    context,
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, MOENGAGE_FLUTTER_LIBRARY_VERSION),
                    isSdkEnabled
                )
            } catch (e: Exception) {
                Logger.e("$tag initialize() : Exception: ", e)
            }
        }
    }
}