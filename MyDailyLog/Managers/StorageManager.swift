//
//  StorageManager.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/17/22.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    func uploadUserInfo(userEmail: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func uploadLogHeaderImage(log: Log, completion: @escaping (Bool) -> Void) {
        let fileRef = storage.child("images/\(log.id).jpg")
        let uploadTask = fileRef.putData(log.headerImageUrl, metadata: nil) { metadata, err in
            if err == nil && metadata != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
