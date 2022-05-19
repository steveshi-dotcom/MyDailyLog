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
    
    func insertLog(log: Log, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func deleteLog(log: Log, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func getLog(forUser user: User, completion: @escaping (Log) -> Void) {
        
    }
    func getAllLog(completion: @escaping ([Log]) -> Void) {
        
    }
    func insertUser(user: User, completion: @escaping (Bool) -> Void) {
        
    }
}

