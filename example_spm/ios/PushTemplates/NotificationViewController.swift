//
//  NotificationViewController.swift
//  PushTemplates
//
//  Created by Soumya Mahunt on 16/10/25.
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
