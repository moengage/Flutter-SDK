package com.moengage.flutter.cards

import android.content.Context
import com.moengage.cards.core.model.CardData
import com.moengage.core.internal.utils.postOnMainThread
import com.moengage.plugin.base.cards.CardsPluginHelper
import com.moengage.plugin.base.cards.internal.cardDataToJson
import com.moengage.plugin.base.internal.instanceMetaFromJson
import com.moengage.platform.internal.logger.Logger
import com.moengage.platform.internal.logger.PlatformLogLevel
import com.moengage.platform.internal.resources.PlatformResources
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class PlatformMethodCallHandler(
    private val context: Context,
    private val cardsPluginHelper: CardsPluginHelper,
) : MethodChannel.MethodCallHandler {
    private val tag = "${MODULE_TAG}PlatformMethodCallHandler"

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            if (call.arguments == null) {
                Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() ${call.method}: Arguments null" }
                return
            }
            Logger.record { "$tag onMethodCall() : Method: ${call.method}" }
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
                METHOD_FETCH_CARDS -> fetchCards(call, result)
                else -> {
                    Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() : Method Not supported : ${call.method}" }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    private fun initialize(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag initialize() : MoEngage Cards plugin initialised. $payload" }
            cardsPluginHelper.initialise(payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag initialize() : " }
        }
    }

    private fun refreshCards(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag refreshCards() : $payload" }
            cardsPluginHelper.refreshCards(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag refreshCards() : " }
        }
    }

    private fun onCardsSectionLoaded(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag onCardsSectionLoaded() : $payload" }
            cardsPluginHelper.onCardSectionLoaded(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag onCardsSectionLoaded() : " }
        }
    }

    private fun onCardsSectionUnLoaded(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag onCardsSectionUnLoaded() : $payload" }
            cardsPluginHelper.onCardSectionUnLoaded(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag onCardsSectionUnLoaded() : " }
        }
    }

    private fun cardClicked(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag cardClicked() : $payload" }
            cardsPluginHelper.cardClicked(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag cardClicked() : " }
        }
    }

    private fun cardDelivered(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag cardDelivered() : $payload" }
            cardsPluginHelper.cardDelivered(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag cardDelivered() : " }
        }
    }

    private fun cardShown(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag cardShown() : $payload" }
            cardsPluginHelper.cardShown(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag cardShown() : " }
        }
    }

    private fun deleteCards(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag deleteCards() : $payload" }
            cardsPluginHelper.deleteCards(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR) { "$tag deleteCards() : " }
        }
    }

    private fun getCardsInfo(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag getCardsInfo() : $payload" }
            PlatformResources.executor.submit {
                val cardsInfo = cardsPluginHelper.getCardsInfo(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag getCardsInfo(): Result : $cardsInfo" }
                        result.success(cardsInfo)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsInfo() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsInfo() : " }
        }
    }

    private fun fetchCards(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val payload = call.arguments.toString()
        try {
            Logger.record { "$tag fetchCards() : $payload" }
            PlatformResources.executor.submit {
                cardsPluginHelper.fetchCards(context, payload, cardAvailableListener = {
                    postOnMainThread {
                        Logger.record { "$tag fetchCards(): Result Success: $it" }
                        result.success(getCardPayload(it, payload).toString())
                    }
                })
            }
        } catch (t: Throwable) {
            result.success(getCardPayload(null, payload).toString())
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag fetchCards() : " }
        }
    }

    private fun getCardsCategories(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag getCardsCategories() : $payload" }
            PlatformResources.executor.submit {
                val categories = cardsPluginHelper.getCardsCategories(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag getCardsCategories():  Result : $categories" }
                        result.success(categories)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsCategories() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsCategories() : " }
        }
    }

    private fun getCardsForCategory(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag getCardsForCategory() : $payload" }
            PlatformResources.executor.submit {
                val cards = cardsPluginHelper.getCardsForCategory(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag getCardsForCategory(): Result : $cards" }
                        result.success(cards)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsCategories() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getCardsForCategory() : " }
        }
    }

    private fun isAllCategoryEnabled(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag isAllCategoryEnabled() : $payload" }
            PlatformResources.executor.submit {
                val isAllCategoryEnabled = cardsPluginHelper.isAllCategoryEnabled(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag isAllCategoryEnabled(): Result : $isAllCategoryEnabled" }
                        result.success(isAllCategoryEnabled)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag isAllCategoryEnabled() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag isAllCategoryEnabled() : " }
        }
    }

    private fun getNewCardsCount(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag getNewCardsCount() : $payload" }
            PlatformResources.executor.submit {
                val newCardsCountResult = cardsPluginHelper.getNewCardsCount(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag getNewCardsCount(): Result : $newCardsCountResult" }
                        result.success(newCardsCountResult)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag getNewCardsCount() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getNewCardsCount() : " }
        }
    }

    private fun getUnClickedCardsCount(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val payload = call.arguments.toString()
            Logger.record { "$tag getUnClickedCardsCount() : $payload" }
            PlatformResources.executor.submit {
                val unClickedCardsCount = cardsPluginHelper.getUnClickedCardsCount(context, payload)
                postOnMainThread {
                    try {
                        Logger.record { "$tag getUnClickedCardsCount(): Result : $unClickedCardsCount" }
                        result.success(unClickedCardsCount)
                    } catch (t: Throwable) {
                        Logger.record(PlatformLogLevel.ERROR, t) { "$tag getUnClickedCardsCount() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getUnClickedCardsCount() : " }
        }
    }

    private fun getCardPayload(
        cardData: CardData?,
        payload: String,
    ): JSONObject {
        return cardDataToJson(cardData, instanceMetaFromJson(JSONObject(payload)))
    }
}