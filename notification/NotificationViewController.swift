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
    
    @IBOutlet weak var cashIcon: UIImageView!
    
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
    
    @IBOutlet weak var photoIcon: UIImageView!
    @IBOutlet weak var goodIcon: UIImageView!
    @IBOutlet weak var copyIcon: UIImageView!
    @IBOutlet weak var laminationIcon: UIImageView!
    @IBOutlet weak var serviceIcon: UIImageView!
    
    
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
        let childrens = Mirror(reflecting: today).children
        var data = [Int: String]()
        var prevBar: RoundedCornerView?
        let sum: Double = Double(today.sum())
        
        for (_, attr) in childrens.enumerated() {
            let value = attr.value as? Int
            
            if value == nil || value == 0 {
                continue;
            }
            
            let name = attr.label!
            if name == "total" || name == "printing" {
                continue
            }
            
            data.updateValue(name, forKey: value!)
        }
        
        for (value, name) in data.sorted(by: >) {
            var bar: RoundedCornerView?
            var icon: UIImageView?
            
            switch name {
                case "photo":
                    bar = photoBar
                    icon = photoIcon
                case "good":
                    bar = goodBar
                    icon = goodIcon
                case "copy":
                    bar = copyBar
                    icon = copyIcon
                case "lamination":
                    bar = laminationBar
                    icon = laminationIcon
                case "service":
                    bar = serviceBar
                    icon = serviceIcon
                default:
                    continue
            }
            
            let percent: Double = sum != 0 ? viewMultiplier * Double(value) / sum : 0.0
            
            self.view.addConstraint(NSLayoutConstraint(item: bar!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: CGFloat(percent), constant: 0))
            
            if prevBar == nil {
                self.view.addConstraint(NSLayoutConstraint(item: bar!, attribute: .top, relatedBy: .equal, toItem: self.cashIcon, attribute: .bottom, multiplier: 1, constant: 48))
            } else {
                self.view.addConstraint(NSLayoutConstraint(item: bar!, attribute: .top, relatedBy: .equal, toItem: prevBar, attribute: .bottom, multiplier: 1, constant: 16))
            }
            
            prevBar = bar!
            
            bar!.isHidden = false
            icon!.isHidden = false
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
