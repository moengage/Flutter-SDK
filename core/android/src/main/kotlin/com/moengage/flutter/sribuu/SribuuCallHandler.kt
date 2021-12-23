package com.moengage.flutter.sribuu

import android.app.Application
import android.content.Context
import com.moengage.core.DataCenter
import com.moengage.core.MoEngage
import com.moengage.core.config.*
import com.moengage.core.internal.logger.Logger
import com.moengage.core.model.IntegrationPartner
import com.moengage.flutter.core.MoEInitializer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*


class SribuuCallHandler(
        private val context: Context,
        private val sribuuChannel: MethodChannel,
        private val tag: String) : MethodChannel.MethodCallHandler {

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call == null) {
                Logger.e(
                        "$tag onMethodCall() : MethodCall instance is null cannot proceed "
                                + "further."
                )
                return
            }
            if (context == null) {
                Logger.e("$tag onMethodCall() : Context is null cannot proceed further.")
                return
            }
            Logger.v(tag + " onMethodCall() : Method " + call.method)
            when (call.method) {
                METHOD_NAME_CONFIGURE_MOENGAGE -> configureMoEngage(call)
                else -> Logger.e("$tag onMethodCall() : No mapping for this method.")
            }
        } catch (e: Exception) {
            Logger.e("$tag onMethodCall() : exception: ", e)
        }
    }

    private fun configureMoEngage(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null || methodCall.argument<String>("appId") == null) return

            val appId = methodCall.argument<String>("appId")
            val setupCalls = methodCall.argument<HashMap<String, HashMap<String, Object>>>("setupCalls")

            val initializerHelperHelper = MoEngageInitializerHelper(context, appId!!, setupCalls!!)
            initializerHelperHelper.initialize()
        } catch (e: Exception) {
            Logger.e("exception: ", e)
        }
    }
}

class MoEngageInitializerHelper(
        private val context: Context,
        private val appId: String,
        private val setupCalls: HashMap<String, HashMap<String, Object>>
) {
    private val builder: MoEngage.Builder = MoEngage.Builder(context as Application, appId!!)

    fun initialize() {
        setNotificationLargeIconIfDeclared()
        setNotificationSmallIconIfDeclared()
        setSenderIdIfDeclared()
        setNotificationColorIfDeclared()
        setNotificationToneIfDeclared()
        enableMultipleNotificationInDrawerIfDeclared()
        optOutInAppOnActivityIfDeclared()
        optOutBackStackBuilderIfDeclared()
        optOutNavBarIfDeclared()
        optOutTokenRegistrationIfDeclared()
        enableLogsForSignedBuildIfDeclared()
        optOutNotificationLargeIconIfDeclared()
        enableSegmentIntegrationIfDeclared()
        enablePushKitTokenRegistrationIfDeclared()
        setTokenRetryIntervalIfDeclared()
        enableEncryptionIfDeclared()
        configureMiPushIfDeclared()
        enableLogsIfDeclared()
        setDataCenterIfDeclared()
        configureFcmIfDeclared()
        configureCardsIfDeclared()
        configureMiPushConfigIfDeclared()
        configureTrackingOptOutIfDeclared()
        configureRealTimeTriggerIfDeclared()
        configurePushKitIfDeclared()
        configureNotificationMetaDataIfDeclared()
        configureInAppConfigIfDeclared()
        configureLogsIfDeclared()
        configureGeofenceIfDeclared()
        enablePartnerIntegrationIfDeclared()

        builder.build()
        MoEInitializer.initialize(context, builder)
    }

    private fun setNotificationLargeIconIfDeclared() {
        if(setupCalls.containsKey("setNotificationLargeIcon")) {
            val largeIcon: Int = setupCalls["setNotificationLargeIcon"]!!["largeIcon"]!! as Int

            builder.setNotificationLargeIcon(largeIcon!!)
        }
    }

    private fun setNotificationSmallIconIfDeclared() {
        if(setupCalls.containsKey("setNotificationSmallIcon")) {
            val smallIcon: Int = setupCalls["setNotificationSmallIcon"]!!["smallIcon"]!! as Int

            builder.setNotificationSmallIcon(smallIcon)
        }
    }

    private fun setSenderIdIfDeclared() {
        if(setupCalls.containsKey("setSenderId")) {
            val senderId: String = setupCalls["setSenderId"]!!["senderId"]!! as String

            builder.setSenderId(senderId)
        }
    }

    private fun setNotificationColorIfDeclared() {
        if(setupCalls.containsKey("setNotificationColor")) {
            val color: Int = setupCalls["setNotificationColor"]!!["color"]!! as Int

            builder.setNotificationColor(color)
        }
    }

    private fun setNotificationToneIfDeclared() {
        if(setupCalls.containsKey("setNotificationTone")) {
            val tone: String = setupCalls["setNotificationTone"]!!["tone"]!! as String

            builder.setNotificationTone(tone)
        }
    }

    private fun enableMultipleNotificationInDrawerIfDeclared() {
        if(setupCalls.containsKey("enableMultipleNotificationInDrawer")) {
            builder.enableMultipleNotificationInDrawer()
        }
    }

    private fun optOutInAppOnActivityIfDeclared() {
        if(setupCalls.containsKey("optOutInAppOnActivity")) {
            val inAppOptOutClassNameList: List<String> = setupCalls["optOutInAppOnActivity"]!!["inAppOptOutClassNameList"]!! as List<String>
            val inAppOptOutClassList = inAppOptOutClassNameList.map { Class.forName(it) }

            builder.optOutInAppOnActivity(inAppOptOutClassList)
        }
    }

    private fun optOutBackStackBuilderIfDeclared() {
        if(setupCalls.containsKey("optOutBackStackBuilder")) {
            builder.optOutBackStackBuilder()
        }
    }

    private fun optOutNavBarIfDeclared() {
        if(setupCalls.containsKey("optOutNavBar")) {
            builder.optOutNavBar()
        }
    }

    private fun optOutTokenRegistrationIfDeclared() {
        if(setupCalls.containsKey("optOutTokenRegistration")) {
            builder.optOutTokenRegistration()
        }
    }

    private fun enableLogsForSignedBuildIfDeclared() {
        if(setupCalls.containsKey("enableLogsForSignedBuild")) {
            builder.enableLogsForSignedBuild()
        }
    }

    private fun optOutNotificationLargeIconIfDeclared() {
        if(setupCalls.containsKey("optOutNotificationLargeIcon")) {
            builder.optOutNotificationLargeIcon()
        }
    }

    private fun enableSegmentIntegrationIfDeclared() {
        if(setupCalls.containsKey("enableSegmentIntegration")) {
            builder.enableSegmentIntegration()
        }
    }

    private fun enablePushKitTokenRegistrationIfDeclared() {
        if(setupCalls.containsKey("enablePushKitTokenRegistration")) {
            builder.enablePushKitTokenRegistration()
        }
    }

    private fun setTokenRetryIntervalIfDeclared() {
        if(setupCalls.containsKey("setTokenRetryInterval")) {
            val tokenRetryInterval: Long = setupCalls["setTokenRetryInterval"]!!["tokenRetryInterval"]!! as Long

            builder.setTokenRetryInterval(tokenRetryInterval)
        }
    }

    private fun enableEncryptionIfDeclared() {
        if(setupCalls.containsKey("enableEncryption")) {
            builder.enableEncryption()
        }
    }

    private fun configureMiPushIfDeclared() {
        if(setupCalls.containsKey("configureMiPush")) {
            val appId: String = setupCalls["configureMiPush"]!!["appId"]!! as String
            val appKey: String = setupCalls["configureMiPush"]!!["appKey"]!! as String
            val enableTokenRegistration: Boolean = setupCalls["configureMiPush"]!!["enableTokenRegistration"]!! as Boolean

            builder.configureMiPush(MiPushConfig(appId, appKey, enableTokenRegistration))
        }
    }

    private fun enableLogsIfDeclared() {
        if(setupCalls.containsKey("enableLogs")) {
            val level: Int = setupCalls["enableLogs"]!!["level"]!! as Int

            builder.enableLogs(level)
        }
    }

    private fun setDataCenterIfDeclared() {
        if(setupCalls.containsKey("setDataCenter")) {
            val dataCenterAsString: String = setupCalls["setDataCenter"]!!["dataCenter"]!! as String
            val dataCenter: DataCenter = DataCenter.valueOf(dataCenterAsString)
            builder.setDataCenter(dataCenter)
        }
    }

    private fun configureFcmIfDeclared() {
        if(setupCalls.containsKey("configureFcm")) {
            val isRegistrationEnabled: Boolean = setupCalls["configureFcm"]!!["isRegistrationEnabled"]!! as Boolean
            val senderId: String = setupCalls["configureFcm"]!!["senderId"]!! as String

            builder.configureFcm(FcmConfig(isRegistrationEnabled, senderId))
        }
    }

    private fun configureCardsIfDeclared() {
        if(setupCalls.containsKey("configureCards")) {
            val cardPlaceHolderImage: Int = setupCalls["configureCards"]!!["cardPlaceHolderImage"]!! as Int
            val inboxEmptyImage: Int = setupCalls["configureCards"]!!["inboxEmptyImage"]!! as Int
            val cardsDateFormat: String = setupCalls["configureCards"]!!["cardsDateFormat"]!! as String
            val isSwipeRefreshEnabled: Boolean = setupCalls["configureCards"]!!["isSwipeRefreshEnabled"]!! as Boolean

            builder.configureCards(CardConfig(cardPlaceHolderImage, inboxEmptyImage, cardsDateFormat, isSwipeRefreshEnabled))
        }
    }

    private fun configureMiPushConfigIfDeclared() {
        if(setupCalls.containsKey("configureMiPushConfig")) {
            val appId: String = setupCalls["configureMiPushConfig"]!!["appId"]!! as String
            val appKey: String = setupCalls["configureMiPushConfig"]!!["appKey"]!! as String
            val isRegistrationEnabled: Boolean = setupCalls["configureMiPushConfig"]!!["isRegistrationEnabled"]!! as Boolean

            builder.configureMiPush(MiPushConfig(appId, appKey, isRegistrationEnabled))
        }
    }

    private fun configureTrackingOptOutIfDeclared() {
        if(setupCalls.containsKey("configureTrackingOptOut")) {
            val isGaidTrackingEnabled: Boolean = setupCalls["configureTrackingOptOut"]!!["isGaidTrackingEnabled"]!! as Boolean
            val isAndroidIdTrackingEnabled: Boolean = setupCalls["configureTrackingOptOut"]!!["isAndroidIdTrackingEnabled"]!! as Boolean
            val isCarrierTrackingEnabled: Boolean = setupCalls["configureTrackingOptOut"]!!["isCarrierTrackingEnabled"]!! as Boolean
            val isDeviceAttributeTrackingEnabled: Boolean = setupCalls["configureTrackingOptOut"]!!["isDeviceAttributeTrackingEnabled"]!! as Boolean
            val optOutActivitiesClassName: List<String> = setupCalls["configureTrackingOptOut"]!!["optOutActivitiesClassName"]!! as List<String>
            val optOutActivitiesClassSet = optOutActivitiesClassName.map { Class.forName(it) }.toHashSet()

            builder.configureTrackingOptOut(TrackingOptOutConfig(isGaidTrackingEnabled, isAndroidIdTrackingEnabled, isCarrierTrackingEnabled, isDeviceAttributeTrackingEnabled, optOutActivitiesClassSet))
        }
    }

    private fun configureRealTimeTriggerIfDeclared() {
        if(setupCalls.containsKey("configureRealTimeTrigger")) {
            val isBackgroundSyncEnabled: Boolean = setupCalls["configureRealTimeTrigger"]!!["isBackgroundSyncEnabled"]!! as Boolean

            builder.configureRealTimeTrigger(RttConfig(isBackgroundSyncEnabled))
        }
    }

    private fun configurePushKitIfDeclared() {
        if(setupCalls.containsKey("configurePushKit")) {
            val isRegistrationEnabled: Boolean = setupCalls["configurePushKit"]!!["isRegistrationEnabled"]!! as Boolean

            builder.configurePushKit(PushKitConfig(isRegistrationEnabled))
        }
    }

    private fun configureNotificationMetaDataIfDeclared() {
        if(setupCalls.containsKey("configureNotificationMetaData")) {
            val smallIcon: Int = setupCalls["configureNotificationMetaData"]!!["smallIcon"]!! as Int
            val largeIcon: Int = setupCalls["configureNotificationMetaData"]!!["largeIcon"]!! as Int
            val notificationColor: Int = setupCalls["configureNotificationMetaData"]!!["notificationColor"]!! as Int
            val tone: String? = setupCalls["configureNotificationMetaData"]!!["tone"] as String?
            val isMultipleNotificationInDrawerEnabled: Boolean = setupCalls["configureNotificationMetaData"]!!["isMultipleNotificationInDrawerEnabled"]!! as Boolean
            val isBuildingBackStackEnabled: Boolean = setupCalls["configureNotificationMetaData"]!!["isBuildingBackStackEnabled"]!! as Boolean
            val isLargeIconDisplayEnabled: Boolean = setupCalls["configureNotificationMetaData"]!!["isLargeIconDisplayEnabled"]!! as Boolean

            builder.configureNotificationMetaData(NotificationConfig(smallIcon, largeIcon, notificationColor, tone, isMultipleNotificationInDrawerEnabled, isBuildingBackStackEnabled, isLargeIconDisplayEnabled))
        }
    }

    private fun configureInAppConfigIfDeclared() {
        if(setupCalls.containsKey("configureInAppConfig")) {
            val shouldHideStatusBar: Boolean = setupCalls["configureInAppConfig"]!!["shouldHideStatusBar"]!! as Boolean
            val isJavascriptEnabled: Boolean = setupCalls["configureInAppConfig"]!!["isJavascriptEnabled"]!! as Boolean
            val optOutActivitiesClassNameList: List<String> = setupCalls["configureInAppConfig"]!!["optOutActivitiesClassName"]!! as List<String>
            val activityNames: List<String> = setupCalls["configureInAppConfig"]!!["activityNames"]!! as List<String>

            val optOutActivities = optOutActivitiesClassNameList.map { Class.forName(it) }.toHashSet()
            val config = InAppConfig(shouldHideStatusBar, optOutActivities, isJavascriptEnabled)
            config.addActivityName(activityNames.toHashSet())

            builder.configureInApps(config)
        }
    }

    private fun configureLogsIfDeclared() {
        if(setupCalls.containsKey("configureLogs")) {
            val level: Int = setupCalls["configureLogs"]!!["level"]!! as Int
            val isEnabledForReleaseBuild: Boolean = setupCalls["configureLogs"]!!["isEnabledForReleaseBuild"]!! as Boolean

            builder.configureLogs(LogConfig(level, isEnabledForReleaseBuild))
        }
    }

    private fun configureGeofenceIfDeclared() {
        if(setupCalls.containsKey("configureGeofence")) {
            val isGeofenceEnabled: Boolean = setupCalls["configureGeofence"]!!["isGeofenceEnabled"]!! as Boolean
            val isBackgroundSyncEnabled: Boolean = setupCalls["configureGeofence"]!!["isBackgroundSyncEnabled"]!! as Boolean

            builder.configureGeofence(GeofenceConfig(isGeofenceEnabled, isBackgroundSyncEnabled))
        }
    }

    private fun enablePartnerIntegrationIfDeclared() {
        if(setupCalls.containsKey("enablePartnerIntegration")) {
            val integrationPartnerString: String = setupCalls["enablePartnerIntegration"]!!["integrationPartner"]!! as String
            val integrationPartner: IntegrationPartner = IntegrationPartner.valueOf(integrationPartnerString)

            builder.enablePartnerIntegration(integrationPartner)
        }
    }
}
