//
//  Today.swift
//  notification
//
//  Created by Сергей Прищенко on 24.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import WidgetKit
import SwiftUI

struct TodayWidget: Widget {
    private let kind: String = "today"

    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider(),
            placeholder: PlaceholderView()
        ) { entry in
                entryView(entry: entry)
        }
        .configurationDisplayName("Today Widget")
        .description("This is an example widget.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
//            .systemLarge,
        ])
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let summary: TodaySummary
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct entryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Entry
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")

    @ViewBuilder
    var body: some View {
        if self.sharedDefaults!.string(forKey: "token") == nil {
            AuthView()
        } else {
            switch family {
            case .systemSmall: SmallWidget(entry: entry)
            case .systemMedium: MediumWidget(entry: entry)
            case .systemLarge: SmallWidget(entry: entry)
            }
        }
    }
}

struct SmallWidget : View {
    var entry: Entry

    var body: some View {
        CashView(value: entry.summary.cash.today.total)
    }
}

struct MediumWidget : View {
    var entry: Entry

    var body: some View {
        HStack {
            CashView(value: entry.summary.cash.today.total)
            ClientView(value: entry.summary.client.today)
        }
    }
}

struct Provider: TimelineProvider {
    public func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), summary: TodaySummary(cash: Cash(today: Today(total: 420)), client: Client(today: 36)))
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [Entry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = Entry(date: entryDate, summary: TodaySummary(cash: Cash(today: Today(total: 420)), client: Client(today: 36)))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}