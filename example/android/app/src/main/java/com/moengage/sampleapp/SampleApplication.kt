package com.moengage.sampleapp

import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.FcmConfig
import com.moengage.core.config.LogConfig
import com.moengage.core.config.MoEngageEnvironmentConfig
import com.moengage.core.config.NotificationConfig
import com.moengage.core.config.PushKitConfig
import com.moengage.core.model.AccountMeta
import com.moengage.core.model.SdkState
import com.moengage.core.model.environment.MoEngageEnvironment
import com.moengage.flutter.MoEInitializer
import com.moengage.pushbase.MoEPushHelper
import io.flutter.app.FlutterApplication
import com.moengage.inapp.MoEInAppHelper

/**
 * @author Umang Chamaria
 * Date: 2019-12-13
 */
class SampleApplication : FlutterApplication() {

    private const val APP_ID = "<YOUR_APP_ID>"
    override fun onCreate() {
        super.onCreate()
        val moEngage: MoEngage.Builder = MoEngage.Builder(this, APP_ID)
            .configureNotificationMetaData(
                NotificationConfig(
                    R.drawable.icon,
                    R.drawable.ic_launcher,
                    notificationColor = -1,
                    isMultipleNotificationInDrawerEnabled = false,
                    isBuildingBackStackEnabled = true,
                    isLargeIconDisplayEnabled = true
                )
            )
            .configureLogs(LogConfig(LogLevel.VERBOSE, true))
            .configureFcm(FcmConfig(true))
            .configurePushKit(PushKitConfig(true))
            .configureMoEngageEnvironment(MoEngageEnvironmentConfig(MoEngageEnvironment.DEFAULT))
        MoEInitializer.initialiseDefaultInstance(applicationContext, moEngage, SdkState.ENABLED,true)
        // optional, required in-case notification customisation is required.
        MoEPushHelper.getInstance().registerMessageListener(CustomPushListener(AccountMeta(APP_ID)))
        MoEInAppHelper.getInstance().enableActivityRegistrationOnResume()
    }
}