//
//  HomeModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase
import SwiftUI

class HomeModel: ObservableObject {
    @Published var logPost: [Log] = []
    
    var userName: String {
        var retrievedname: String = ""
        let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getUser(withEmail: email) {(result: Result<User, DatabaseManager.FireStoreError>) in
            switch result {
            case .success(let iUser):
                retrievedname = iUser.userName
            case .failure:
                retrievedname = "Anonomous Panda"
            }
        }
        return retrievedname
    }
    
    func loadLogs(completion: @escaping (Bool) -> Void) {
        let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getLogs(withEmail: email) { result in
            if result.count != 0 {
                self.logPost = result
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
