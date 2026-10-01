package com.moengage.flutter.recommendations

import android.content.Context
import com.moengage.core.internal.utils.postOnMainThread
import com.moengage.platform.internal.logger.Logger
import com.moengage.platform.internal.logger.PlatformLogLevel
import com.moengage.plugin.base.recommendations.RecommendationsHelper
import com.moengage.plugin.base.recommendations.RecommendationsListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PlatformMethodCallHandler(
    private val context: Context,
    private val recommendationsHelper: RecommendationsHelper,
) : MethodChannel.MethodCallHandler {
    private val tag = "${MODULE_TAG}PlatformMethodCallHandler"

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            if (call.arguments == null) {
                Logger.record(PlatformLogLevel.ERROR) {
                    "$tag onMethodCall() ${call.method}: Arguments null"
                }
                // Settled rather than dropped — every method on this channel returns a result, so
                // returning silently would leave the Dart Future pending forever.
                result.error(REASON_UNKNOWN_ERROR, "Arguments null", null)
                return
            }
            Logger.record { "$tag onMethodCall() : Method: ${call.method}" }
            when (call.method) {
                METHOD_FETCH_RECOMMENDATIONS -> fetchRecommendations(call, result)
                else -> {
                    Logger.record(PlatformLogLevel.ERROR) {
                        "$tag onMethodCall() : Method Not supported : ${call.method}"
                    }
                    result.notImplemented()
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag onMethodCall() : " }
            result.error(REASON_UNKNOWN_ERROR, t.message, null)
        }
    }

    private fun fetchRecommendations(
        call: MethodCall,
        methodChannelResult: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag fetchRecommendations() : $payload" }
            recommendationsHelper.fetchRecommendations(
                context,
                payload,
                object : RecommendationsListener {
                    override fun onSuccess(result: String) {
                        postOnMainThread {
                            try {
                                Logger.record { "$tag fetchRecommendations(): Result : $result" }
                                methodChannelResult.success(result)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) {
                                    "$tag fetchRecommendations() : "
                                }
                            }
                        }
                    }

                    override fun onFailure(
                        reason: String,
                        message: String,
                    ) {
                        postOnMainThread {
                            try {
                                Logger.record(PlatformLogLevel.ERROR) {
                                    "$tag fetchRecommendations(): Error : $reason - $message"
                                }
                                methodChannelResult.error(reason, message, null)
                            } catch (t: Throwable) {
                                Logger.record(PlatformLogLevel.ERROR, t) {
                                    "$tag fetchRecommendations() : "
                                }
                            }
                        }
                    }
                },
            )
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchRecommendations() : " }
            // The Dart side is awaiting this call — the result has to be settled, or the Future
            // never completes.
            methodChannelResult.error(REASON_UNKNOWN_ERROR, t.message, null)
        }
    }
}
