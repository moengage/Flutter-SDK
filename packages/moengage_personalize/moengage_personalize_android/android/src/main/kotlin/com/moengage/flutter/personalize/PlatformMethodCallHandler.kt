package com.moengage.flutter.personalize

import android.content.Context
import com.moengage.core.internal.utils.postOnMainThread
import com.moengage.core.model.RequestFailureReasonCode
import com.moengage.plugin.base.personalization.PersonalizationHelper
import com.moengage.plugin.base.personalization.PersonalizeExperienceListener
import com.moengage.platform.internal.logger.Logger
import com.moengage.platform.internal.logger.PlatformLogLevel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PlatformMethodCallHandler(
    private val context: Context,
    private val personalizationHelper: PersonalizationHelper,
) : MethodChannel.MethodCallHandler {
    private val tag = "${MODULE_TAG}PlatformMethodCallHandler"

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            if (call.arguments == null) {
                Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() ${call.method}: Arguments null" }
                return
            }
            Logger.record { "$tag onMethodCall() : Method: ${call.method}" }
            when (call.method) {
                METHOD_FETCH_EXPERIENCES_META -> fetchExperiencesMeta(call, result)
                METHOD_FETCH_EXPERIENCES -> fetchExperiences(call, result)
                METHOD_EXPERIENCES_SHOWN -> experiencesShown(call)
                METHOD_EXPERIENCE_CLICKED -> experienceClicked(call)
                METHOD_OFFERINGS_SHOWN -> offeringsShown(call)
                METHOD_OFFERING_CLICKED -> offeringClicked(call)
                else -> {
                    Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() : Method Not supported : ${call.method}" }
                    result.notImplemented()
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag onMethodCall() : " }
            result.error("exception", t.message, null)
        }
    }

    private fun fetchExperiencesMeta(
        call: MethodCall,
        methodChannelResult: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag fetchExperiencesMeta() : $payload" }
            personalizationHelper.fetchExperiencesMeta(
                context,
                payload,
                object : PersonalizeExperienceListener {
                    override fun onSuccess(result: String) {
                        postOnMainThread {
                            try {
                                Logger.record { "$tag fetchExperiencesMeta(): Result : $result" }
                                methodChannelResult.success(result)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
                            }
                        }
                    }

                    override fun onFailure(
                        reason: RequestFailureReasonCode,
                        message: String,
                    ) {
                        postOnMainThread {
                            try {
                                Logger.record(PlatformLogLevel.ERROR) { "$tag fetchExperiencesMeta(): Error : $reason - $message" }
                                methodChannelResult.error(reason.name, message, null)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
                            }
                        }
                    }
                },
            )
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
        }
    }

    private fun fetchExperiences(
        call: MethodCall,
        methodChannelResult: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag fetchExperiences() : $payload" }
            personalizationHelper.fetchExperiences(
                context,
                payload,
                object : PersonalizeExperienceListener {
                    override fun onSuccess(result: String) {
                        postOnMainThread {
                            try {
                                Logger.record { "$tag fetchExperiences(): Result : $result" }
                                methodChannelResult.success(result)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiences() : " }
                            }
                        }
                    }

                    override fun onFailure(
                        reason: RequestFailureReasonCode,
                        message: String,
                    ) {
                        postOnMainThread {
                            try {
                                Logger.record(PlatformLogLevel.ERROR) { "$tag fetchExperiences(): Error : $reason - $message" }
                                methodChannelResult.error(reason.name, message, null)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiences() : " }
                            }
                        }
                    }
                },
            )
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchExperiences() : " }
        }
    }

    private fun experiencesShown(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag experiencesShown() : $payload" }
            personalizationHelper.experiencesShown(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag experiencesShown() : " }
        }
    }

    private fun experienceClicked(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag experienceClicked() : $payload" }
            personalizationHelper.experienceClicked(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag experienceClicked() : " }
        }
    }

    private fun offeringsShown(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag offeringsShown() : $payload" }
            personalizationHelper.offeringsShown(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag offeringsShown() : " }
        }
    }

    private fun offeringClicked(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag offeringClicked() : $payload" }
            personalizationHelper.offeringClicked(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag offeringClicked() : " }
        }
    }
}