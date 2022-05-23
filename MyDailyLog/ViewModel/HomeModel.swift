//
//  HomeModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class HomeModel: ObservableObject {
    @Published var username: String = ""
    @Published var logPost: [Log] = []
 
    init() {
        if username == "" {
            getName()
        }
    }
    
    func getName() {
        let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getUser(withEmail: email) {[unowned self] name in
            username = name
        }
    }
    
    func loadLog() {
        
    }
}
