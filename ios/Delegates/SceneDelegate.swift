//
//  SceneDelegate.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var sessionManager: SessionManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
        
        let token = sharedDefaults!.string(forKey: "token")

        sessionManager = SessionManager(token: token)
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = RootView(sessionManager: sessionManager!)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let manager = sessionManager else {
            return
        }
        
        guard let socket = manager.socket else {
            return
        }
        
        socket.connect()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let manager = sessionManager else {
            return
        }
        
        guard let socket = manager.socket else {
            return
        }
        
        socket.disconnect()
    }


}
