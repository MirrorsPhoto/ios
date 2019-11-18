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
    
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var signIn: UIButton!
    
    private var token: String? = nil
    private var isAuth: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
        self.token = sharedDefaults?.string(forKey: "token")
        
        self.isAuth = self.token != nil
        
        if !self.isAuth {
            self.signIn.isHidden = false
            
            return
        }
        
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
            
            guard let result = responseJSON["response"] as? [String: Int] else {
                return
            }
            
            guard let cash = result["cash"] else {
                return
            }
            
            guard let client = result["client"] else {
                return
            }
            
            self.cashLabel.text = "Cash: \(cash)"
            self.clientLabel.text = "Client: \(client)"
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("widgetPerformUpdate")
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func openApp(_ sender: UIButton) {
        let url = URL(string: "mirrorsPhoto://")!
        self.extensionContext?.open(url, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
}
