/*
 * Copyright (c) 2014-2022 MoEngage Inc.
 *
 * All rights reserved.
 *
 *  Use of source code or binaries contained within MoEngage SDK is permitted only to enable use of the MoEngage platform by customers of MoEngage.
 *  Modification of source code and inclusion in mobile apps is explicitly allowed provided that all other conditions are met.
 *  Neither the name of MoEngage nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 *  Redistribution of source code or binaries is disallowed except with specific prior written permission. Any such redistribution must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.moengage.push.amp.plus

import android.app.ActivityManager
import android.content.Context
import android.os.Process
import com.moengage.core.LogLevel
import com.moengage.core.internal.MANUFACTURER_XIAOMI
import com.moengage.core.internal.global.GlobalResources
import com.moengage.core.internal.logger.Logger
import com.moengage.core.internal.utils.MoEUtils
import com.moengage.core.internal.utils.jsonToBundle
import com.moengage.mi.MoEMiPushHelper
import com.moengage.pushbase.MoEPushHelper
import com.xiaomi.channel.commonutils.android.Region
import com.xiaomi.mipush.sdk.ErrorCode
import com.xiaomi.mipush.sdk.MiPushClient
import com.xiaomi.mipush.sdk.MiPushCommandMessage
import com.xiaomi.mipush.sdk.MiPushMessage
import org.json.JSONObject

/**
 * Helper class to integrate Push-Amp-Plus module of the MoEngage SDK.
 *
 * @author Umang Chamaria
 * @since 1.0.0
 */
public object MiPushHelper {

    private const val tag = "MiPushHelper"

    /**
     * Helper method to pass notification click callback to the MoEngage SDK.
     *
     * @param context instance of [Context]
     * @param message instance of [MiPushMessage]
     * @since 1.0.0
     */
    public fun onNotificationClicked(context: Context, message: MiPushMessage) {
        try {
            Logger.print { "$tag onNotificationClicked() : Notification clicked: $message" }
            val messageContent = message.content
            if (messageContent.isNullOrBlank()) return
            val pushPayload = jsonToBundle(JSONObject(messageContent)) ?: return
            MoEMiPushHelper.getInstance().onNotificationClicked(context, pushPayload)
        } catch (e: Throwable) {
            Logger.print(LogLevel.ERROR, e) { "$tag onNotificationClicked() : " }
        }
    }

    /**
     * Helper method to pass the notification payload to the MoEngage SDK.
     *
     * @param context instance of [Context]
     * @param message instance of [MiPushMessage]
     * @since 1.0.0
     */
    public fun passPushPayload(context: Context, message: MiPushMessage) {
        try {
            Logger.print { "$tag passPushPayload() : $message" }
            val messageContent = message.content
            if (messageContent.isNullOrBlank()) return
            val pushPayload = jsonToBundle(JSONObject(messageContent))
            MoEMiPushHelper.getInstance().passPushPayload(context, pushPayload)
        } catch (e: Exception) {
            Logger.print(LogLevel.ERROR, e) { "$tag passPushPayload() : " }
        }
    }

    /**
     * Helper method to pass the Push token to the MoEngage SDK.
     *
     * @param context instance of [Context]
     * @param message instance of [MiPushCommandMessage]
     * @since 1.0.0
     */
    public fun passPushToken(context: Context, message: MiPushCommandMessage) {
        try {
            Logger.print { "$tag passPushToken() : Message: $message" }
            val command = message.command
            if (MiPushClient.COMMAND_REGISTER != command) {
                Logger.print { "$tag passPushToken() : Received command is not register command." }
                return
            }
            if (message.resultCode != ErrorCode.SUCCESS.toLong()) {
                Logger.print { "$tag passPushToken() : Registration failed." }
                return
            }
            val arguments = message.commandArguments ?: return
            val pushToken = if (arguments.size > 0) arguments[0] else null
            if (pushToken.isNullOrEmpty()) {
                Logger.print { "$tag passPushToken() : Token is null or empty." }
                return
            }
            MoEMiPushHelper.getInstance().passPushToken(context, pushToken)
        } catch (e: Throwable) {
            Logger.print(LogLevel.ERROR, e) { "$tag passPushToken() : " }
        }
    }

    /**
     * Helper API to check if the payload is from MoEngage platform or not.
     *
     * @param message instance of [MiPushMessage]
     * @since 1.0.0
     */
    public fun isFromMoEngagePlatform(message: MiPushMessage): Boolean {
        try {
            val messageContent = message.content
            if (messageContent.isNullOrBlank()) return false
            val payload = jsonToBundle(JSONObject(messageContent))
            return MoEPushHelper.getInstance().isFromMoEngagePlatform(payload)
        } catch (e: Throwable) {
            Logger.print(LogLevel.ERROR, e) { "$tag isFromMoEngagePlatform() : " }
        }
        return false
    }

    /**
     * Initialise Mi SDK
     *
     * @param context instance of [Context]
     * @param appId App-Id from the Mi Dashboard.
     * @param appKey App-Key from the Mi Dashboard.
     * @param region The region in which the Mi data should reside. Set the region using [Region].
     *
     * @since 1.0.0
     */
    public fun initialiseMiPush(context: Context, appKey: String, appId: String, region: Region) {
        if (MANUFACTURER_XIAOMI != MoEUtils.deviceManufacturer()) {
            Logger.print(LogLevel.WARN) { "$tag initialiseMiPush() : Not a Xiaomi device, rejecting Mi token." }
            return
        }
        if (!MoEMiPushHelper.getInstance().hasMiUi()) {
            Logger.print { "$tag initialiseMiPush() : Device Does not have Mi Ui will not register for mi push" }
            return
        }
        setDataRegion(context, region)
        initialise(context, appId, appKey, region)
    }

    /**
     * Set the region in which the Mi data reside.
     *
     * @param context: instance of [Context]
     * @param region: The region in which the Mi data reside. Set the region using [Region].
     *
     * @since 1.0.0
     */
    public fun setDataRegion(context: Context, region: Region) {
        try {
            MoEMiPushHelper.getInstance().setDataRegion(context, region.toString().lowercase())
        } catch (e: Throwable) {
            Logger.print(LogLevel.ERROR, e) { "$tag setDataRegion() : " }
        }
    }

    private fun isMainProcess(context: Context): Boolean {
        val am =
            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager ?: return false
        val processInfos = am.runningAppProcesses
        val mainProcessName = context.packageName
        val myPid = Process.myPid()
        for (info in processInfos) {
            if (info.pid == myPid && mainProcessName == info.processName) {
                return true
            }
        }
        return false
    }

    private fun initialise(context: Context, appId: String, appKey: String, region: Region) {
        try {
            Logger.print { "$tag initialiseMiPush() : Will initialise Mi Push if required." }
            Logger.print { "$tag initialiseMiPush(): AppId: $appId AppKey: $appKey" }
            if (!isMainProcess(context)) {
                Logger.print { "$tag initialiseMiPush() : Will not initialise, not the main process" }
                return
            }
            Logger.print { "$tag initialiseMiPush() : Will register for Mi Push" }
            GlobalResources.executor.execute {
                MiPushClient.setRegion(region)
                MiPushClient.registerPush(context.applicationContext, appId, appKey)
            }
        } catch (e: Throwable) {
            Logger.print(LogLevel.ERROR, e) { "$tag initialiseMiPush() : " }
        }
    }
}