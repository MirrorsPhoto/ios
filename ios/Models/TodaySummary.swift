// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let todaySummary = try? newJSONDecoder().decode(TodaySummary.self, from: jsonData)

import Foundation

// MARK: - TodaySummary
class TodaySummary: Codable {
    var cash: Cash
    var client: Client

    init(cash: Cash = Cash(), client: Client = Client()) {
        self.cash = cash
        self.client = client
    }
}

// MARK: - Cash
class Cash: Codable {
    var today: Today
    var yesterday, week, month, year: Int

    init(today: Today = Today(), yesterday: Int = 0, week: Int = 0, month: Int = 0, year: Int = 0) {
        self.today = today
        self.yesterday = yesterday
        self.week = week
        self.month = month
        self.year = year
    }
}

// MARK: - Today
class Today: Codable {
    var photo, good, copy, lamination, printing, service, total: Int

    init(photo: Int = 0, good: Int = 0, copy: Int = 0, lamination: Int = 0, printing: Int = 0, service: Int = 0, total: Int = 0) {
        self.photo = photo
        self.good = good
        self.copy = copy
        self.lamination = lamination
        self.printing = printing
        self.service = service
        self.total = total
    }
}

// MARK: - Client
class Client: Codable {
    var today, yesterday, week, month, year: Int

    init(today: Int = 0, yesterday: Int = 0, week: Int = 0, month: Int = 0, year: Int = 0) {
        self.today = today
        self.yesterday = yesterday
        self.week = week
        self.month = month
        self.year = year
    }
}
