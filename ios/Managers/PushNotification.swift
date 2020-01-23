//
//  PushNotification.swift
//  ios
//
//  Created by Сергей Прищенко on 23.01.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

class PushNotification {
    
    static let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    static func register() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
        
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    static func registerDeviceToken(_ deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
          return String(format: "%02.2hhx", data)
        }
        
        let deviceToken = tokenParts.joined()
        self.sharedDefaults!.set(deviceToken, forKey: "device_token")
        
        let token = self.sharedDefaults?.string(forKey: "token")
        
        if token == nil {
            return
        }
        
        let parameters: Parameters = [
            "token": deviceToken,
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/device/subscribe", method: .post, parameters: parameters, headers: headers)
    }
    
    static func unregisterDeviceToken() {
        let token = self.sharedDefaults?.string(forKey: "token")
        let deviceToken = self.sharedDefaults?.string(forKey: "device_token")
        
        if token == nil || deviceToken == nil {
            return
        }
        
        let parameters: Parameters = [
            "token": deviceToken!,
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        print(parameters)
        Alamofire.request("http://api.mirrors-photo.ru/device/unsubscribe", method: .post, parameters: parameters, headers: headers)
    }
    
    static func failRegister(_ error: Error) {
        print("Failed to register: \(error)")
    }
    
}
