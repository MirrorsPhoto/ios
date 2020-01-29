//
//  NotificationViewController.swift
//  notification
//
//  Created by Сергей Прищенко on 27.01.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cash: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
//        let userInfo = notification.request.content.userInfo
//        let data = userInfo["data"] as! NSDictionary
//        let time = userInfo["time"] as! String
//        
//        let now = Date(timeIntervalSince1970: Double(time)!)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy"
//        self.date.text = formatter.string(from: now)
//        
//        let cash = data["cash"] as! [String: Any]
//        let todayCash = cash["today"] as! [String: Int]
//        let cashTodayTotal = todayCash["total"] as! Int
//        
//        self.cash.text = Helper.formatCurrency(cashTodayTotal)
    }

}
