//
//  MoEngageFlutterCardsConstants.swift
//  moengage_cards
//
//  Created by Soumya Mahunt on 22/06/23.
//

import Foundation

enum MoEngageFlutterCardsConstants {
    static let pluginChannelName = "com.moengage/cards"

    enum FlutterToNativeMethods {
        static let initialize = "initialize"
        static let refreshCards = "refreshCards"
        static let fetchCards = "fetchCards"
        static let onCardSectionLoaded = "onCardSectionLoaded"
        static let cardGenericSync = "setSyncCompleteListener"
        static let onCardSectionUnloaded = "onCardSectionUnLoaded"
        static let getCardsCategories = "getCardsCategories"
        static let cardsInfo = "getCardsInfo"
        static let cardClicked = "cardClicked"
        static let cardDelivered = "cardDelivered"
        static let cardShown = "cardShown"
        static let cardsForCategory = "cardsForCategory"
        static let deleteCards = "deleteCards"
        static let isAllCategoryEnabled = "isAllCategoryEnabled"
        static let newCardsCount = "getNewCardsCount"
        static let unClickedCardsCount = "unClickedCardsCount"
    }

    enum NativeToFlutterMethods {
        static let inboxOpenCardsSync = "onInboxOpenCardsSync"
        static let pullToRefreshCardsSync = "onPullToRefreshCardsSync"
        static let cardGenericSync = "onCardsSync"
    }
}
