package com.moengage.flutter.personalize

import android.content.Context
import com.moengage.campaigns.personalize.PersonalizeExperienceListener
import com.moengage.campaigns.personalize.PersonalizationHelper
import com.moengage.core.LogLevel
import com.moengage.core.internal.global.GlobalResources
import com.moengage.core.internal.logger.Logger
import com.moengage.core.model.RequestFailureReasonCode
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
                Logger.print(LogLevel.ERROR) { "$tag onMethodCall() ${call.method}: Arguments null" }
                return
            }
            Logger.print { "$tag onMethodCall() : Method: ${call.method}" }
            when (call.method) {
                METHOD_FETCH_EXPERIENCES_META -> fetchExperiencesMeta(call, result)
                METHOD_FETCH_EXPERIENCES -> fetchExperiences(call, result)
                METHOD_EXPERIENCES_SHOWN -> experiencesShown(call)
                METHOD_EXPERIENCE_CLICKED -> experienceClicked(call)
                METHOD_OFFERINGS_SHOWN -> offeringsShown(call)
                METHOD_OFFERING_CLICKED -> offeringClicked(call)
                else -> {
                    Logger.print(LogLevel.ERROR) { "$tag onMethodCall() : Method Not supported : ${call.method}" }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    private fun fetchExperiencesMeta(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag fetchExperiencesMeta() : $payload" }
            GlobalResources.executor.submit {
                personalizationHelper.fetchExperiencesMeta(
                    context,
                    payload,
                    object : PersonalizeExperienceListener {
                        override fun onSuccess(resultPayload: String) {
                            GlobalResources.mainThread.post {
                                try {
                                    Logger.print { "$tag fetchExperiencesMeta(): Result : $resultPayload" }
                                    result.success(resultPayload)
                                } catch (t: Throwable) {
                                    Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
                                }
                            }
                        }

                        override fun onFailure(
                            reason: RequestFailureReasonCode,
                            message: String,
                        ) {
                            GlobalResources.mainThread.post {
                                try {
                                    Logger.print(LogLevel.ERROR) { "$tag fetchExperiencesMeta(): Error : $reason - $message" }
                                    result.error(reason.name, message, null)
                                } catch (t: Throwable) {
                                    Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
                                }
                            }
                        }
                    },
                )
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiencesMeta() : " }
        }
    }

    private fun fetchExperiences(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag fetchExperiences() : $payload" }
            GlobalResources.executor.submit {
                personalizationHelper.fetchExperiences(
                    context,
                    payload,
                    object : PersonalizeExperienceListener {
                        override fun onSuccess(resultPayload: String) {
                            GlobalResources.mainThread.post {
                                try {
                                    Logger.print { "$tag fetchExperiences(): Result : $resultPayload" }
                                    result.success(resultPayload)
                                } catch (t: Throwable) {
                                    Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiences() : " }
                                }
                            }
                        }

                        override fun onFailure(
                            reason: RequestFailureReasonCode,
                            message: String,
                        ) {
                            GlobalResources.mainThread.post {
                                try {
                                    Logger.print(LogLevel.ERROR) { "$tag fetchExperiences(): Error : $reason - $message" }
                                    result.error(reason.name, message, null)
                                } catch (t: Throwable) {
                                    Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiences() : " }
                                }
                            }
                        }
                    },
                )
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag fetchExperiences() : " }
        }
    }

    private fun experiencesShown(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag experiencesShown() : $payload" }
            personalizationHelper.experiencesShown(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag experiencesShown() : " }
        }
    }

    private fun experienceClicked(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag experienceClicked() : $payload" }
            personalizationHelper.experienceClicked(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag experienceClicked() : " }
        }
    }

    private fun offeringsShown(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag offeringsShown() : $payload" }
            personalizationHelper.offeringsShown(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag offeringsShown() : " }
        }
    }

    private fun offeringClicked(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag offeringClicked() : $payload" }
            personalizationHelper.offeringClicked(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag offeringClicked() : " }
        }
    }
}
