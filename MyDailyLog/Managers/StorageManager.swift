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
    
    // Upload the image to Firebase Storage with the path provided
    func uploadLogHeaderImage(log: Log, withEmail email: String, completion: @escaping (Result<Bool, StorageError>) -> Void) {
        let fileRef = storage.child("images/\(email)/\(log.id).jpg")
        let _ = fileRef.putData(log.headerImageUrl, metadata: nil) { metadata, err in
            if err == nil && metadata != nil {
                completion(.success(true))
            } else {
                completion(.failure(.failedUpload))
            }
        }
    }
    
    
    // Upload the userPicture to Firebase Storage under name userPic within the userEmail
    func uploadUserPic(withImage img: Data, withPath path: String, completion: @escaping (Result<Bool, StorageError>) -> Void) {
        print("Working inner workings.")
        let fileRef = storage.child(path)
        let _ = fileRef.putData(img, metadata: nil) { metadata, err in
            if err == nil && metadata != nil {
                completion(.success(true))
            } else {
                completion(.failure(.failedUpload))
            }
        }
    }
    
    // Retrieve the image from Firebase Storage with the path provided
    func getLogHeaderImage(withPath path: String, completion: @escaping (Result<UIImage, StorageError>) -> Void) {
        let fileRef = storage.child(path)
        let _ = fileRef.getData(maxSize: .max) { data, err in
            if err == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        completion(.success(image))
                        return
                    }
                }
            } else {
                completion(.failure(.failedRetrieval))
            }
        }
    }
    
    //
}

