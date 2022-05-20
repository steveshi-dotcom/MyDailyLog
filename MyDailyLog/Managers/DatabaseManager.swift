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
    
    enum FireStoreError: String, Error, LocalizedError, Identifiable {
        case failedUpload = "Failed to upload data to Firebase FireStore"
        case failedRetrieval = "Failed to retrieve data from Firebase FireStore"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    private init() {}
    
    // Insert the log info such as uuid, timestamp, body text, image caption,
    // and store the image in FireStorage since the file size would be too big
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
        StorageManager.shared.uploadLogHeaderImage(log: log) { (result: Result<Bool, StorageManager.StorageError>) in
            switch result {
            case .success:
                completion(true)
            case .failure(let iError):
                print(iError.rawValue)
                completion(false)
            }
        }
    }
    func insertUser(user: User, completion: @escaping (Bool) -> Void) {
        db
            .collection("users")
            .document(user.userEmail)
            .collection("userInfo")
            .document("info")
            .setData(["userName": user.userName, "userEmail": user.userEmail]) { err in
                completion(err != nil)
            }
    }
    
    func deleteUser(user: User, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .document(user.userEmail)
            .delete() { err in
                completion(err == nil)
            }
    }
}

