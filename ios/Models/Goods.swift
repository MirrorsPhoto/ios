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
    let description: String
    let bar_code: String?
    let price: Int
    let available: Int
}
