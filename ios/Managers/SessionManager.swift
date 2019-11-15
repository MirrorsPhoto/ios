//
//  SessionStore.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//
import Combine
import JWTDecode
import Starscream
import Alamofire

class SessionManager : ObservableObject, WebSocketDelegate {
    
    @Published var isLogin = false
    @Published var user: User?
    @Published var socket: WebSocket?
    @Published var token: String?
    @Published var data: [String: Any]?
    @Published var totalCash: Int?
    @Published var totalClient: Int?
    
    init(token: String? = nil) {
        if token == nil {
            return
        }
        
        self.token = token!
        
        setToken(token: token!)
        initSocket(token: token!)
    }
    
    func signIn(token: String) {
        setToken(token: token)
        initSocket(token: token)
    }
    
    func logOut() {
        self.isLogin = false
        self.user = nil
        closeSocket()
    }
    
    private func setToken(token: String) {
        let jwt = try? decode(jwt: token)
        
        self.user = User(data: jwt?.body)
        self.isLogin = true
    }
    
    private func initSocket(token: String) {
        self.socket = WebSocket(url: URL(string: "ws://socket.mirrors-photo.ru:8000?token=\(token)")!)
        
        self.socket!.delegate = self
        self.socket!.connect()
    }
    
    private func closeSocket() {
        self.socket?.disconnect()
        self.socket = nil
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/socket/update", headers: headers)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        self.data = convertToDictionary(text: text)
        self.totalCash = getTodayCash()
        self.totalClient = getTodayClient()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getTodayCash() -> Int {
        guard let cash = self.data!["cash"] as? [String: Any] else {
            return 0
        }
        guard let today = cash["today"] as? [String: Int] else {
            return 0
        }
        guard let total = today["total"] else {
            return 0
        }
        
        return total
    }
    
    func getTodayClient() -> Int {
        guard let client = self.data!["client"] as? [String: Int] else {
           return 0
       }
        guard let today = client["today"] else {
           return 0
       }
       
       return today
    }
}
