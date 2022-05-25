//
//  User.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/17/22.
//

import Foundation

struct User {
    let userName: String
    let userEmail: String
    let userImage: Data
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userEmail
    }
}
