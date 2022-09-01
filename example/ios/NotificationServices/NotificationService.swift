//
//  NotificationService.swift
//  NotificationServices
//
//  Created by Chengappa C D on 06/11/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UserNotifications
import MoEngageRichNotification

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        MORichNotification.setAppGroupID("group.com.alphadevs.MoEngage.NotificationServices")
        MORichNotification.handle(richNotificationRequest: request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
