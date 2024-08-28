package com.moengage.flutter

internal object GlobalCache {
    // Flag to Enable Queuing of events on App Background and on next App Open, the events will be flushed.
    var lifecycleAwareCallbackEnabled: Boolean = false
}