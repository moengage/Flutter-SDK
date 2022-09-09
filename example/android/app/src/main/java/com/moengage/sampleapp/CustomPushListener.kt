package com.moengage.sampleapp

import android.app.Activity
import android.content.Context
import android.os.Bundle
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.push.PluginPushCallback

/**
 * @author Umang Chamaria
 * Date: 2020/12/06
 */
class CustomPushListener : PluginPushCallback() {

    private val tag = "CustomPushListener"
    override fun handleCustomAction(context: Context, payload: String) {
        super.handleCustomAction(context, payload)
        Logger.print { "$tag handleCustomAction() : " }
    }

    override fun onNotificationClick(activity: Activity, payload: Bundle) {
        super.onNotificationClick(activity, payload)
        Logger.print { "$tag onNotificationClick() : " }
    }

}