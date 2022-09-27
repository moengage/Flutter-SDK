package com.moengage.flutter

import android.content.Context
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
        @Deprecated(
            message = "This method is deprecated.",
            ReplaceWith(expression = "MoEInitializer.initialiseDefaultInstance()")
        )

        /**
         * Initialise the default instance of SDK with configuration provided in [MoEngage.Builder]
         *
         * @param context Context
         * @param builder Instance of [MoEngage.Builder]
         */
        @JvmStatic
        fun initialiseDefaultInstance(context: Context, builder: MoEngage.Builder) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(
                        INTEGRATION_TYPE,
                        MOENGAGE_FLUTTER_LIBRARY_VERSION
                    ),
                    SdkState.ENABLED
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseDefaultInstance() : " }
            }
        }

        /**
         * Initialise the default instance of SDK with configuration provided in [MoEngage.Builder] and
         * SDK state, i.e. whether the SDK should be in enabled or disabled state.
         *
         * By default the SDK is enabled. Use this API only if you have a requirement to
         * enable/disable SDK, else use [MoEngage.initialiseDefaultInstance].
         *
         * **Note:** State is persisted across session, once the SDK is disabled it will remain
         * in disabled state until enabled again.
         *
         * @param context Context
         * @param builder Instance of [MoEngage.Builder]
         * @param sdkState [SdkState]
         */
        @JvmStatic
        fun initialiseDefaultInstance(context: Context, builder: MoEngage.Builder, sdkState: SdkState) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, MOENGAGE_FLUTTER_LIBRARY_VERSION),
                    sdkState
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseDefaultInstance() : " }
            }
        }
    }
}