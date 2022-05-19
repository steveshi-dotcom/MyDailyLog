//
//  BlogPost.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/17/22.
//

import Foundation

struct Log: Codable, Identifiable {
    let id: String
    let timeStamp: TimeInterval
    let headerImageUrl: Data
    let headerImageCap: String
    let bodyText: String
}
