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
    
    enum StorageError: String, Error, LocalizedError, Identifiable {
        case failedUpload = "Failed to upload data to Firebase Storage"
        case failedRetrieval = "Failed to retrieve data from Firebase Storage"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    private init() {}
    
    func uploadLogHeaderImage(log: Log, withEmail email: String, completion: @escaping (Result<Bool, StorageError>) -> Void) {
        let fileRef = storage.child("images/\(log.id).jpg")
        let _ = fileRef.putData(log.headerImageUrl, metadata: nil) { metadata, err in
            if err == nil && metadata != nil {
                completion(.success(true))
            } else {
                completion(.failure(.failedUpload))
            }
        }
    }
    
    func getLogHeaderImage(withID id: String, completion: @escaping (Result<UIImage, StorageError>) -> Void) {
        let fileRef = storage.child("images\(id).jpg")
        let _ = fileRef.getData(maxSize: .max) { data, err in
            if err == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        completion(.success(image))
                        return
                    }
                }
            }
            completion(.failure(.failedRetrieval))
        }
    }
}

