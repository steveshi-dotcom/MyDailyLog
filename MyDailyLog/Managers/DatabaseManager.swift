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
    
    func dummyTest() {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

    }
    
    func insertBlog(blogPost: Log, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func deleteBlog(blogPost: Log, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func getAllPost(completion: @escaping ([Log]) -> Void) {
        
    }
    func getPost(forUser user: User, completion: @escaping (Log) -> Void) {
        
    }
    func insertUser(user: User, completion: @escaping (Bool) -> Void) {
        
    }
}

