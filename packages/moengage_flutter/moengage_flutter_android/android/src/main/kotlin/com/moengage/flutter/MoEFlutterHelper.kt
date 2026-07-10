package com.moengage.flutter

import com.moengage.core.internal.inapp.InAppManager
import com.moengage.inapp.MoEInAppHelper
import com.moengage.platform.internal.logger.Logger

/**
 * @author Arshiya Khanum
 */
public class MoEFlutterHelper {
    private val tag = "${MODULE_TAG}MoEFlutterHelper"

    public companion object {
        private var instance: MoEFlutterHelper? = null

        @JvmStatic
        public fun getInstance(): MoEFlutterHelper {
            return instance ?: synchronized(MoEFlutterHelper::class.java) {
                val inst = instance ?: MoEFlutterHelper()
                instance = inst
                inst
            }
        }
    }

    public fun onConfigurationChanged() {
        Logger.record { "$tag onConfigurationChanged() : " }
        if (!InAppManager.hasModule()) {
            Logger.record { "$tag onConfigurationChanged() : InApp module not found." }
            return
        }
        MoEInAppHelper.getInstance().onConfigurationChanged()
    }
}