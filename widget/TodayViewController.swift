//
//  TodayViewController.swift
//  widget
//
//  Created by Сергей Прищенко on 17.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    private var token: String? = nil
    private var isAuth: Bool = false
    private var todaySummary = TodaySummary()
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var cashIcon: UIImageView!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var cashValue: UILabel!
    @IBOutlet weak var clientIcon: UIImageView!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var clientValue: UILabel!
    
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
    
    var myConstrains = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        self.token = self.sharedDefaults!.string(forKey: "token")
        
        self.isAuth = self.token != nil
        
        if !self.isAuth {
            self.signIn.isHidden = false
            
            return
        }
        
        if let savedTodaySummary = self.sharedDefaults!.object(forKey: "todaySummary") as? Data {
            if let loadedTodaySummary = try? JSONDecoder().decode(TodaySummary.self, from: savedTodaySummary) {
                self.todaySummary = loadedTodaySummary
            }
        }
        
        updateWidget()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/sale/today", headers: headers).responseJSON { (response) in
            let todayResponse = try! JSONDecoder().decode(TodayResponse.self, from: response.data!)
            
            self.todaySummary = todayResponse.response
            
            if let encoded = try? JSONEncoder().encode(self.todaySummary) {
                self.sharedDefaults!.set(encoded, forKey: "todaySummary")
            }
            
            self.updateWidget()
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("widgetPerformUpdate")
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: 280)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    @IBAction func openApp(_ sender: UIButton) {
        let url = URL(string: "mirrorsPhoto://")!
        self.extensionContext?.open(url, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
    
    private func updateWidget() {
        setCash(self.todaySummary.cash.today.total)
        setClient(self.todaySummary.client.today)
        setBarWidth(self.todaySummary.cash.today)
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
        
        let sortedData = data.sorted(by: >)
        
        self.view.removeConstraints(self.myConstrains)
        
        for (value, name) in sortedData {
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
                    break
            }
            
            let percent: Double = sum != 0 ? viewMultiplier * Double(value) / sum : 0.0
            let widthConstraint = NSLayoutConstraint(item: bar!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: CGFloat(percent), constant: 0)
            
            self.view.addConstraint(widthConstraint)
            self.myConstrains.append(widthConstraint)
            
            var topConstraint = NSLayoutConstraint(item: bar!, attribute: .top, relatedBy: .equal, toItem: self.cashIcon, attribute: .bottom, multiplier: 1, constant: 48)

            if prevBar != nil {
                topConstraint = NSLayoutConstraint(item: bar!, attribute: .top, relatedBy: .equal, toItem: prevBar, attribute: .bottom, multiplier: 1, constant: 16)
            }
            self.view.addConstraint(topConstraint)
            self.myConstrains.append(topConstraint)
            
            prevBar = bar!
            
            bar!.isHidden = false
            icon!.isHidden = false
        }
    }
    
    func setCash(_ value: Int) {
        self.cashIcon.isHidden = false
        self.cashValue.isHidden = false
        self.cashLabel.isHidden = false
        self.cashLabel.text = NSLocalizedString("Cash", comment: "")
        self.cashValue.text = Helper.formatCurrency(value)
    }
    
    func setClient(_ value: Int) {
        self.clientIcon.isHidden = false
        self.clientValue.isHidden = false
        self.clientLabel.isHidden = false
        self.clientLabel.text = NSLocalizedString("Client", comment: "")
        self.clientValue.text = String.localizedStringWithFormat(NSLocalizedString("Client value", comment: ""), String(value))
    }
    
}
