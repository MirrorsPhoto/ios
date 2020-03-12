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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        self.token = self.sharedDefaults!.string(forKey: "token")
        
        self.isAuth = self.token != nil
        
        if !self.isAuth {
            self.signIn.isHidden = false
            
            return
        }
        
        let cashFromStorage = sharedDefaults?.integer(forKey: "cashTotal") ?? 0
        let clientFromStorage = sharedDefaults?.integer(forKey: "clientTotal") ?? 0
        
        self.setCash(cashFromStorage)
        self.setClient(clientFromStorage)

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/sale/today", headers: headers).responseJSON { (response) in
            guard let responseJSON = response.result.value as? [String: Any] else {
                return
            }
            
            guard responseJSON["status"] as! String == "OK" else {
                return
            }
            
            guard let result = responseJSON["response"] as? [String: Any] else {
                return
            }
            
            self.updateWidget(result)
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
    
    private func updateWidget(_ data: [String: Any]) {
        guard let client = data["client"] as? [String: Int] else {
            return
        }
        guard let cash = data["cash"] as? [String: Any] else {
            return
        }
        guard let cashToday = cash["today"] as? [String: Int] else {
            return
        }
        
        let today = Today(photo: cashToday["photo"] ?? 0, good: cashToday["good"] ?? 0, copy: cashToday["copy"] ?? 0, lamination: cashToday["lamination"] ?? 0, printing: cashToday["printing"] ?? 0, service: cashToday["service"] ?? 0, total: cashToday["total"] ?? 0)
        
        
        setCash(today.total)
        setClient(client["today"]!)
        setBarWidth(today)
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
                    break
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
        self.cashIcon.isHidden = false
        self.cashValue.isHidden = false
        self.cashLabel.isHidden = false
        self.cashLabel.text = NSLocalizedString("Cash", comment: "")
        self.cashValue.text = Helper.formatCurrency(value)
        
        self.sharedDefaults!.set(value, forKey: "cashTotal")
    }
    
    func setClient(_ value: Int) {
        self.clientIcon.isHidden = false
        self.clientValue.isHidden = false
        self.clientLabel.isHidden = false
        self.clientLabel.text = NSLocalizedString("Client", comment: "")
        self.clientValue.text = String.localizedStringWithFormat(NSLocalizedString("Client value", comment: ""), String(value))
        
        self.sharedDefaults!.set(value, forKey: "clientTotal")
    }
    
}
