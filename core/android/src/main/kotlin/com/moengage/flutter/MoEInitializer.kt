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

        @Deprecated(
            message = "This method is deprecated.",
            ReplaceWith(expression = "MoEInitializer.initialiseDefaultInstance()")
        )
        @JvmStatic
        fun initialize(builder: MoEngage.Builder) {
            try {
                Logger.print { "$tag initialize() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(
                        INTEGRATION_TYPE,
                        MOENGAGE_FLUTTER_LIBRARY_VERSION
                    )
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialize() : " }
            }
        }

        @Deprecated(
            message = "This method is deprecated.",
            ReplaceWith(expression = "MoEInitializer.initialiseDefaultInstance()")
        )
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

        /**
         * Initialise the default instance of SDK with configuration provided in [MoEngage.Builder]
         *
         * @param moEngage: Instance of [MoEngage.Builder]
         */
        @JvmStatic
        fun initialiseDefaultInstance(builder: MoEngage.Builder) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(
                        INTEGRATION_TYPE,
                        MOENGAGE_FLUTTER_LIBRARY_VERSION
                    )
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
         * @param builder: Instance of [MoEngage.Builder]
         * @param isSdkEnabled true if SDK is enabled, else false.
         */
        @JvmStatic
        fun initialiseDefaultInstance(builder: MoEngage.Builder, isSdkEnabled: Boolean) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, MOENGAGE_FLUTTER_LIBRARY_VERSION),
                    if (isSdkEnabled) SdkState.ENABLED else SdkState.DISABLED
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseDefaultInstance() : " }
            }
        }


        /**
         * Initialise the SDK with configuration provided in [MoEngage.Builder]
         *
         * @param builder: Instance of [MoEngage.Builder]
         */
        @JvmStatic
        public fun initialiseInstance(builder: MoEngage.Builder) {
            try {
                Logger.print { "$tag initialiseInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(
                        INTEGRATION_TYPE,
                        MOENGAGE_FLUTTER_LIBRARY_VERSION
                    )
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseInstance() : " }
            }
        }

        /**
         * Initialise the SDK with configuration provided in [MoEngage.Builder] and
         * SDK state, i.e. whether the SDK should be in enabled or disabled state.
         *
         * By default the SDK is enabled. Use this API only if you have a requirement to
         * enable/disable SDK, else use [MoEngage.initialiseInstance].
         *
         * **Note:** State is persisted across session, once the SDK is disabled it will remain
         * in disabled state until enabled again.
         *
         * @param builder: Instance of [MoEngage.Builder]
         * @param isSdkEnabled true if SDK is enabled, else false.
         */
        @JvmStatic
        @Throws(IllegalStateException::class)
        public fun initialiseInstance(builder: MoEngage.Builder, isSdkEnabled: Boolean) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, MOENGAGE_FLUTTER_LIBRARY_VERSION),
                    if (isSdkEnabled) SdkState.ENABLED else SdkState.DISABLED
                )
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseDefaultInstance() : " }
            }
        }
    }
}