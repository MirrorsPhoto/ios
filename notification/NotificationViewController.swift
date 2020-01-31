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
    @IBOutlet weak var client: UILabel!
    
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    
    @IBOutlet weak var photoBar: RoundedCornerView!
    @IBOutlet weak var goodBar: RoundedCornerView!
    @IBOutlet weak var copyBar: RoundedCornerView!
    @IBOutlet weak var laminationBar: RoundedCornerView!
    @IBOutlet weak var serviceBar: RoundedCornerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let data = userInfo["data"] as! String
        let todaySummary = try! JSONDecoder().decode(TodaySummary.self, from: data.data(using: .utf8)!)
        let datetime = Date(timeIntervalSince1970: Double(userInfo["time"] as! String)!)
        
        
        setDate(datetime)
        setCash(todaySummary.cash.today.total)
        setClient(todaySummary.client.today)
        setBarWidth(todaySummary.cash.today)
    }
    
    func setDate(_ date: Date) {
        var text = NSLocalizedString("Today", comment: "")
        
        if Calendar.current.isDateInYesterday(date) {
            text = NSLocalizedString("Yesterday", comment: "")
        } else if !Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            text = formatter.string(from: date)
        }
        
        self.date.text = text
    }
    
    func setBarWidth(_ today: Today) {
        let viewMultiplier = 0.8
        let todayTotal = Double(today.total)
        
        let items = [
            [
                "view": self.photoBar!,
                "multiplier": todayTotal != 0.0 ? viewMultiplier * Double(today.photo) / todayTotal : 0.0
            ],
            [
                "view": self.goodBar!,
                "multiplier": todayTotal != 0.0 ? viewMultiplier * Double(today.good) / todayTotal : 0.0
            ],
            [
                "view": self.copyBar!,
                "multiplier": todayTotal != 0.0 ? viewMultiplier * Double(today.copy) / todayTotal : 0.0
            ],
            [
                "view": self.laminationBar!,
                "multiplier": todayTotal != 0.0 ? viewMultiplier * Double(today.lamination) / todayTotal : 0.0
            ],
            [
                "view": self.serviceBar!,
                "multiplier": todayTotal != 0.0 ? viewMultiplier * Double(today.service) / todayTotal : 0.0
            ]
        ]
        
        for item in items {
            let constraint = NSLayoutConstraint(item: item["view"]!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: CGFloat(item["multiplier"] as! Double), constant: 0)
            
            self.view.addConstraint(constraint)
        }
    }
    
    func setCash(_ value: Int) {
        self.cashLabel.text = NSLocalizedString("Cash", comment: "")
        self.cash.text = Helper.formatCurrency(value)
    }
    
    func setClient(_ value: Int) {
        self.clientLabel.text = NSLocalizedString("Client", comment: "")
        self.client.text = String.localizedStringWithFormat(NSLocalizedString("Client value", comment: ""), String(value))
    }

}
