package com.moengage.flutter

import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.internal.logger.Logger
import com.moengage.core.internal.model.IntegrationMeta
import com.moengage.core.model.SdkState
import com.moengage.plugin.base.internal.PluginInitializer
import org.json.JSONObject

/**
 * @author Umang Chamaria
 * Date: 2019-12-03
 */
class MoEInitializer {
    companion object {
        private const val tag: String = "${MODULE_TAG}MoEInitializer"

        /**
         * Initialise the default instance of SDK with configuration provided in [MoEngage.Builder]
         *
         * @param context Context
         * @param builder Instance of [MoEngage.Builder]
         * @param lifecycleAwareCallbackEnabled - If true, on App background the events will be queued
         * and on App Open the events will be flushed.
         */
        @JvmStatic
        @JvmOverloads
        fun initialiseDefaultInstance(
            context: Context,
            builder: MoEngage.Builder,
            lifecycleAwareCallbackEnabled: Boolean = false
        ) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(
                        INTEGRATION_TYPE,
                        getMoEngageFlutterVersion(context)
                    ),
                    SdkState.ENABLED
                )
                GlobalCache.lifecycleAwareCallbackEnabled = lifecycleAwareCallbackEnabled
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
         * @param lifecycleAwareCallbackEnabled - If true, on App background the events will be queued
         * and on App Open the events will be flushed.
         */
        @JvmStatic
        @JvmOverloads
        fun initialiseDefaultInstance(
            context: Context,
            builder: MoEngage.Builder,
            sdkState: SdkState,
            lifecycleAwareCallbackEnabled: Boolean = false
        ) {
            try {
                Logger.print { "$tag initialiseDefaultInstance() : Will try to initialize the sdk." }
                PluginInitializer.initialize(
                    builder,
                    IntegrationMeta(INTEGRATION_TYPE, getMoEngageFlutterVersion(context)),
                    sdkState
                )
                GlobalCache.lifecycleAwareCallbackEnabled = lifecycleAwareCallbackEnabled
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag initialiseDefaultInstance() : " }
            }
        }

        /**
         * Get moengage_flutter version from Config File
         */
        private fun getMoEngageFlutterVersion(context: Context): String {
            return try {
                val json = context.assets.open(ASSET_CONFIG_FILE_PATH)
                    .bufferedReader().use { it.readText() }
                JSONObject(json).getString(VERSION_KEY)
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag getMoEngageFlutterVersion() : " }
                ""
            }
        }
    }
}