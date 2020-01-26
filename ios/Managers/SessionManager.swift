//
//  SessionStore.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//
import JWT
import Alamofire
import Foundation

class SessionManager : ObservableObject, WebSocketConnectionDelegate {
    
    @Published var isLogin = false
    @Published var user: User?
    @Published var socket: WebSocketTaskConnection?
    @Published var token: String?
    var data: [String: Any]?
    @Published var todaySummary = TodaySummary()
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    init(token: String? = nil) {
        self.todaySummary.cash.today.total = sharedDefaults?.integer(forKey: "cashTotal") ?? 0
        self.todaySummary.client.today = sharedDefaults?.integer(forKey: "clientTotal") ?? 0
        
        if token == nil {
            return
        }
        
        setToken(token: token!)
        initSocket()
    }
    
    func signIn(token: String) {
        setToken(token: token)
        initSocket()
    }
    
    func logOut() {
        sharedDefaults!.removeObject(forKey: "token")
        
        self.isLogin = false
        self.token = nil
        closeSocket()
    }
    
    private func setToken(token: String) {
        let jwt = try? JWT.decode(token, algorithm: .hs256("devkey".data(using: .utf8)!))
        
        self.user = User(data: jwt)
        self.isLogin = true
        self.token = token
    }
    
    func initSocket() {
        if self.token == nil {
            return
        }
        
        self.socket = WebSocketTaskConnection(url: URL(string: "ws://socket.mirrors-photo.ru:8000?token=\(self.token!)")!)
        
        self.socket!.delegate = self
        self.socket!.connect()
    }
    
    func closeSocket() {
        self.socket?.disconnect()
    }
    
    func onConnected(connection: WebSocketConnection) {
        print("Socket connection")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/socket/update", headers: headers)
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        print("websocketDidDisconnect")
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("websocket error")
        print(error)
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        DispatchQueue.main.async {
            self.todaySummary = try! JSONDecoder().decode(TodaySummary.self, from: text.data(using: .utf8)!)
            self.sharedDefaults!.set(self.todaySummary.cash.today.total, forKey: "cashTotal")
            self.sharedDefaults!.set(self.todaySummary.client.today, forKey: "clientTotal")
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("new websocket data")
    }
}
