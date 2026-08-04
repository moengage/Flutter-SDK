package com.moengage.flutter.internal.designmode

/** Physical-pixel bounds of a selected Flutter element, as reported by the Dart element inspector. */
data class DesignModeElementBounds(
    val top: Int,
    val left: Int,
    val bottom: Int,
    val right: Int,
)

/** A marketer-confirmed Flutter element selection, reported from Dart via the method channel. */
data class DesignModeElementSelection(
    val nodeId: String,
    val widgetType: String,
    val path: String,
    val screenName: String,
    val bounds: DesignModeElementBounds,
    val ancestors: List<String>,
    val paused: Boolean,
)

/**
 * Bridges Design Mode element-picker events between the Flutter plugin and the rest of the
 * native MoEngage Android SDK, which registers a [DesignModeElementListener] to be notified
 * when a marketer/QA user selects a Flutter widget to anchor a campaign to.
 */
interface DesignModeElementListener {
    fun onDesignModeActivated()

    fun onDesignModeDeactivated()

    fun onElementSelected(selection: DesignModeElementSelection)
}

internal object DesignModeInstanceProvider {
    private var listener: DesignModeElementListener? = null

    fun setListener(listener: DesignModeElementListener?) {
        this.listener = listener
    }

    fun notifyActivated() {
        listener?.onDesignModeActivated()
    }

    fun notifyDeactivated() {
        listener?.onDesignModeDeactivated()
    }

    fun notifyElementSelected(selection: DesignModeElementSelection) {
        listener?.onElementSelected(selection)
    }
}
