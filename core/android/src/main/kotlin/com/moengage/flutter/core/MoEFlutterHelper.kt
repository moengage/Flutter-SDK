package com.moengage.flutter.core

import com.moengage.inapp.MoEInAppHelper;
import com.moengage.core.internal.logger.Logger
import com.moengage.core.internal.inapp.InAppManager;

/**
 * @author Arshiya Khanum
 */
public class MoEFlutterHelper {

    private val tag = "${CORE_MODULE_TAG}MoEFlutterHelper"

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
        Logger.v("$tag onConfigurationChanged() : ")
        if (!InAppManager.getInstance().hasModule()) {
            Logger.v("$tag onConfigurationChanged() : InApp module not found.")
            return
        }
        MoEInAppHelper.getInstance().onConfigurationChanged()
    }
}