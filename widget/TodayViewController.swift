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
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
        self.token = sharedDefaults?.string(forKey: "token")
        
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
        
        let today = Today(photo: cashToday["photo"]!, good: cashToday["good"]!, copy: cashToday["copy"]!, lamination: cashToday["lamination"]!, printing: cashToday["printing"]!, service: cashToday["service"]!, total: cashToday["total"]!)
        
        
        setCash(today.total)
        setClient(client["today"]!)
        setBarWidth(today)
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
        
        self.photoBar.isHidden = false
        self.photoIcon.isHidden = false
        self.goodBar.isHidden = false
        self.goodIcon.isHidden = false
        self.copyIcon.isHidden = false
        self.copyBar.isHidden = false
        self.laminationBar.isHidden = false
        self.laminationIcon.isHidden = false
        self.serviceBar.isHidden = false
        self.serviceIcon.isHidden = false
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
