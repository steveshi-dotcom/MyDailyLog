//
//  HomeModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class HomeModel: ObservableObject {
    @Published var logPost: [Log] = []
    
    var username: String = ""
    
    func getName() {
        let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getUser(withEmail: email) {name in
            self.username = name
        }
    }
    
    func loadLogs() {
        var name: String = ""
        let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getUser(withEmail: email) { result in
            name = result
        }
        
    }
}
