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
    
    // Insert the log info such as uuid, timestamp, body text, image caption within FireStore Database
    // and store the image in FireStorage since the file size would be too big. Ex: one image captured
    // with jpg compressed to 0.8 is roughly 1.95mb, could possibly make that smaller but would reduce quality
    func insertLog(log: Log, email: String, completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "id": log.id,
            "timestamp": log.timeStamp,
            "headerImageCap": log.headerImageCap,
            "bodyText": log.bodyText,
            "imagePath": "images/\(email)/\(log.id)"
        ]
        db
            .collection("users")
            .document(userEmail)
            .collection("logs")
            .document(log.id)
            .setData(data) { err in // If there are no error with storing the log text info then attempt to store the image within Storage
                if err == nil {
                    StorageManager.shared.uploadLogHeaderImage(log: log, withEmail: email) { (result: Result<Bool, StorageManager.StorageError>) in
                        switch result {
                        case .success:
                            completion(true)
                        case .failure(let iError):
                            print(iError.rawValue)
                            completion(false)
                        }
                    }
                } else {
                    completion(false)
                }
            }
    }
    
    // Insert an order within the path users/userEmail/logPost/userMetaData, each logPost collection will have one distinct userMetaData doc
    func insertUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        db
            .collection("users")
            .document(user.userEmail)
            .collection("logs")
            .document("userMetaData")
            .setData(["userName": user.userName, "userEmail": user.userEmail]) { err in // TODO: Figure out why using the user model won't work
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    // Deleting the user by simply deleting the email field thus deleting all information in the subcollection logPosts
    func deleteUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        db.collection("users")
            .document(user.userEmail)
            .delete() { err in
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
}

