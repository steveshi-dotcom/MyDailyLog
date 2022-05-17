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
    private let container = Storage.storage().reference()
    
    private init() {}
    
    func uploadUserInfo(userEmail: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func uploadBlogHeaderImage(image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
}
