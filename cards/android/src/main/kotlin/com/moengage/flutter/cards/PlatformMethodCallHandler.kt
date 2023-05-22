package com.moengage.flutter.cards

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.cards.CardsPluginHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class PlatformMethodCallHandler(
    private val context: Context,
    private val cardsPluginHelper: CardsPluginHelper
) : MethodChannel.MethodCallHandler {

    private val tag = "${MODULE_TAG}PlatformMethodCallHandler"


    private val executorService = Executors.newCachedThreadPool()

    private val mainThread = Handler(Looper.getMainLooper())


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.arguments == null) {
            Logger.print(LogLevel.ERROR) { "$tag onMethodCall() ${call.method}: Arguments null" }
            return
        }
        when (call.method) {
            METHOD_INITIALIZE -> initialize(call)
            METHOD_REFRESH_CARDS -> refreshCards(call)
            METHOD_ON_CARD_SECTION_LOADED -> onCardsSectionLoaded(call)
            METHOD_ON_CARD_SECTION_UNLOADED -> onCardsSectionUnLoaded(call)
            METHOD_CARDS_INFO -> getCardsInfo(call, result)
            METHOD_GET_CARDS_CATEGORIES -> getCardsCategories(call, result)
            METHOD_CARD_CLICKED -> cardClicked(call)
            METHOD_CARD_DELIVERED -> cardDelivered(call)
            METHOD_CARD_SHOWN -> cardShown(call)
            METHOD_CARDS_FOR_CATEGORY -> getCardsForCategory(call, result)
            METHOD_DELETE_CARDS -> deleteCards(call)
            METHOD_IS_ALL_CATEGORY_ENABLED -> isAllCategoryEnabled(call, result)
            METHOD_NEW_CARDS_COUNT -> getNewCardsCount(call, result)
            METHOD_UN_CLICKED_CARDS_COUNT -> getUnClickedCardsCount(call, result)
            else -> {
                Logger.print(LogLevel.ERROR) { "$tag onMethodCall() : Method Not supported : ${call.method}" }
            }
        }
    }


    private fun initialize(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag initialize() : MoEngage Cards plugin initialised. $payload" }
        cardsPluginHelper.initialise(payload)
    }

    private fun refreshCards(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag refreshCards() : $payload" }
        cardsPluginHelper.refreshCards(context, payload)
    }

    private fun onCardsSectionLoaded(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag onCardsSectionLoaded() : $payload" }
        cardsPluginHelper.onCardSectionLoaded(context, payload)
    }

    private fun onCardsSectionUnLoaded(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag onCardsSectionUnLoaded() : $payload" }
        cardsPluginHelper.onCardSectionUnLoaded(context, payload)
    }

    private fun cardClicked(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag cardClicked() : $payload" }
        cardsPluginHelper.cardClicked(context, payload)
    }

    private fun cardDelivered(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag cardDelivered() : $payload" }
        cardsPluginHelper.cardDelivered(context, payload)
    }

    private fun cardShown(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag cardShown() : $payload" }
        cardsPluginHelper.cardShown(context, payload)
    }

    private fun deleteCards(call: MethodCall) {
        val payload = call.arguments.toString()
        Logger.print { "$tag deleteCards() : $payload" }
        cardsPluginHelper.deleteCards(context, payload)
    }

    private fun getCardsInfo(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getCardsInfo() : $payload" }
            executorService.submit {
                val cardsInfo = cardsPluginHelper.getCardsInfo(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag getCardsInfo(): Result : $cardsInfo" }
                        result.success(cardsInfo)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getCardsInfo() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getCardsInfo() : " }
        }
    }

    private fun getCardsCategories(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getCardsCategories() : $payload" }
            executorService.submit {
                val categories = cardsPluginHelper.getCardsCategories(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag getCardsCategories():  Result : $categories" }
                        result.success(categories)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getCardsCategories() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getCardsCategories() : " }
        }

    }

    private fun getCardsForCategory(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getCardsForCategory() : $payload" }
            executorService.submit {
                val cards = cardsPluginHelper.getCardsForCategory(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag getCardsForCategory(): Result : $cards" }
                        result.success(cards)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getCardsCategories() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getCardsForCategory() : " }
        }
    }


    private fun isAllCategoryEnabled(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag isAllCategoryEnabled() : $payload" }
            executorService.submit {
                val isAllCategoryEnabled = cardsPluginHelper.isAllCategoryEnabled(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag isAllCategoryEnabled(): Result : $isAllCategoryEnabled" }
                        result.success(isAllCategoryEnabled)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag isAllCategoryEnabled() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag isAllCategoryEnabled() : " }
        }
    }

    private fun getNewCardsCount(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getNewCardsCount() : $payload" }
            executorService.submit {
                val newCardsCountResult = cardsPluginHelper.getNewCardsCount(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag getNewCardsCount(): Result : $newCardsCountResult" }
                        result.success(newCardsCountResult)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getNewCardsCount() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getNewCardsCount() : " }
        }
    }

    private fun getUnClickedCardsCount(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getUnClickedCardsCount() : $payload" }
            executorService.submit {
                val unClickedCardsCount = cardsPluginHelper.getUnClickedCardsCount(context, payload)
                mainThread.post {
                    try {
                        Logger.print { "$tag getUnClickedCardsCount(): Result : $unClickedCardsCount" }
                        result.success(unClickedCardsCount)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getUnClickedCardsCount() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getUnClickedCardsCount() : " }
        }
    }
}