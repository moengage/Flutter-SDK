package com.moengage.sampleapp

import android.app.Activity
import android.content.Context
import android.os.Bundle
import com.moengage.core.internal.logger.Logger
import com.moengage.core.model.AccountMeta
import com.moengage.plugin.base.push.PluginPushCallback

/**
 * @author Umang Chamaria
 * Date: 2020/12/06
 */
class CustomPushListener(accountMeta: AccountMeta) : PluginPushCallback(accountMeta) {

    private val tag = "CustomPushListener"

    override fun onNotificationClick(activity: Activity, payload: Bundle): Boolean {
        Logger.print { "$tag onNotificationClick() : " }
        return super.onNotificationClick(activity, payload)
    }

}