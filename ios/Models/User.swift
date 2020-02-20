//
//  User.swift
//  ios
//
//  Created by Сергей Прищенко on 15.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//
import JWT

class User {
    var id: Int
    var firstName: String
    var middleName: String?
    var lastName: String
    var username: String
    var roleId: Int
    var roleName: String
    var email: String
    var avatar: String?
    var sub: String?
    var allowedTypes: [String]
    
    init(data: ClaimSet?) {
        self.id = data?["id"] as! Int
        self.firstName = data?["first_name"] as! String
        self.middleName = data?["middle_name"] as? String
        self.lastName = data?["last_name"] as! String
        self.username = data?["username"] as! String
        self.roleId = data?["role_id"] as! Int
        self.roleName = data?["role_phrase"] as! String
        self.email = data?["email"] as! String
        self.avatar = data?["avatar"] as? String
        self.sub = data?["apple_sub"] as? String
        self.allowedTypes = data?["allowed_types"] as! [String]
    }
}
