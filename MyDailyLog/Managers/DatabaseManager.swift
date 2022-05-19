//
//  EntryService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func insertLog(log: Log, email: String, completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "id": log.id,
            "timestamp": log.timeStamp,
            "headerImageCap": log.headerImageCap,
            "bodyText": log.bodyText
        ]
        db
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(log.id)
            .setData(data) { err in
                completion(err == nil)
            }
        StorageManager.shared.uploadLogHeaderImage(log: log) { result in
            completion(result)
            if result {
                print("Image uploaded successfully")
            }
        }
    }
    func insertUser(user: User, completion: @escaping (Bool) -> Void) {
        
    }
}

