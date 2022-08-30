package com.moengage.flutter

import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.internal.logger.Logger
import com.moengage.core.internal.model.IntegrationMeta
import com.moengage.core.model.SdkState
import com.moengage.flutter.BuildConfig.MOENGAGE_FLUTTER_LIBRARY_VERSION
import com.moengage.plugin.base.internal.PluginInitializer

/**
 * @author Umang Chamaria
 * Date: 2019-12-03
 */
class MoEInitializer {
    companion object {
        private const val tag: String = "${MODULE_TAG}MoEInitializer"

        @JvmStatic
        fun initialize(builder: MoEngage.Builder) {
            try {
                Logger.print { "$tag initialize() : Will try to initialize the sdk." }
                initialize(
                    builder,
                    true
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialize() : " }
            }
        }

        @JvmStatic
        fun initialize(builder: MoEngage.Builder, isSdkEnabled: Boolean) {
            try {
                Logger.print { "$tag initialize() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, MOENGAGE_FLUTTER_LIBRARY_VERSION),
                    if (isSdkEnabled) SdkState.ENABLED else SdkState.DISABLED
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialize() : " }
            }
        }
    }
}