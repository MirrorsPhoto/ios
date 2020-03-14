// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let goodsResponse = try? newJSONDecoder().decode(GoodsResponse.self, from: jsonData)

import Foundation

// MARK: - GoodsResponse
class GoodsResponse: Codable {
    let status: String
    let response: [Good]

    init(status: String, response: [Good]) {
        self.status = status
        self.response = response
    }
}

// MARK: - Good
struct Good: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let bar_code: String?
    let price: Int
    let available: Int
    
    static let `default` = Self(id: 0, name: "", description: nil, bar_code: nil, price: 0, available: 0)
    
    init(id: Int, name: String, description: String?, bar_code: String?, price: Int, available: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.bar_code = bar_code
        self.price = price
        self.available = available
    }
}
