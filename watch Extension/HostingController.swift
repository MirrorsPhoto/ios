//
//  HostingController.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 12.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<RootView> {
    
    let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
    
    override var body: RootView {
        return RootView(sessionManager: SessionManager(token: sharedDefaults!.string(forKey: "token")))
    }
}
