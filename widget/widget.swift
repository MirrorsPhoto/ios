//
//  widget.swift
//  widget
//
//  Created by Сергей Прищенко on 24.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TodayWidget()
    }
}

struct AuthView : View {
    var body: some View {
        Text("Sign in")
    }
}
