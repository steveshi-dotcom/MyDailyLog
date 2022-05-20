//
//  User.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/17/22.
//

import Foundation

struct User {
    var userName: String
    var userEmail: String
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userEmail
    }
}
