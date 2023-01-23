//
//  NotificationViewController.swift
//  PushTemplates
//
//  Created by Chengappa C D on 23/02/21.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MoEngageRichNotification

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoEngageSDKRichNotification.setAppGroupID("group.com.alphadevs.MoEngage.NotificationServices")
    }
    
    func didReceive(_ notification: UNNotification) {
        MoEngageSDKRichNotification.addPushTemplate(toController: self, withNotification: notification)
    }

}
