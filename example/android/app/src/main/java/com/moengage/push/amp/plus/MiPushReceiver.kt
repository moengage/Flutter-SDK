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

import android.content.Context
import com.moengage.core.internal.logger.Logger
import com.xiaomi.mipush.sdk.MiPushCommandMessage
import com.xiaomi.mipush.sdk.MiPushMessage
import com.xiaomi.mipush.sdk.PushMessageReceiver

/**
 * Callback receiver for Mi SDK
 *
 * @author Umang Chamaria
 * @since 1.0.0
 */
public class MiPushReceiver : PushMessageReceiver() {

    private val tag = "MiPushReceiver"

    override fun onReceivePassThroughMessage(context: Context?, message: MiPushMessage?) {
        Logger.print { "$tag onReceivePassThroughMessage() : $message" }
        if (message == null || context == null) return
        if (MiPushHelper.isFromMoEngagePlatform(message)) {
            MiPushHelper.passPushPayload(context, message)
        }
    }

    override fun onNotificationMessageClicked(context: Context?, message: MiPushMessage?) {
        Logger.print { "$tag onNotificationMessageClicked() : $message" }
        if (message == null || context == null) return
        MiPushHelper.onNotificationClicked(context, message)
    }

    override fun onReceiveRegisterResult(context: Context?, message: MiPushCommandMessage?) {
        Logger.print { "$tag onReceiveRegisterResult() : $message" }
        if (message == null || context == null) return
        MiPushHelper.passPushToken(context, message)
    }

    override fun onCommandResult(context: Context?, message: MiPushCommandMessage?) {
        Logger.print { "$tag onCommandResult() : $message" }
        if (message == null || context == null) return
        MiPushHelper.passPushToken(context, message)
    }
}