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
    
    private var token: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
        self.token = sharedDefaults?.string(forKey: "token")
        
        if token != nil {
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
                
                guard var cash = result["cash"] else {
                    return
                }
                
                guard var client = result["client"] else {
                    return
                }
                
                self.cashLabel.text = "Cash: \(cash)"
                self.clientLabel.text = "Client: \(client)"
            }
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("widgetPerformUpdate")
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("widgetActiveDisplayModeDidChange")
    }
    
}
