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
        DatabaseManager.shared.getUser(withEmail: email) {name in
            retrievedname = name
        }
        return retrievedname
    }
    
    func loadLogs(completion: @escaping (Bool) -> Void) {
        //let email = Auth.auth().currentUser?.email ?? "Bob.Builder@gmail.com"
        DatabaseManager.shared.getLogs(withEmail: "st3v5.s2i@gmail.com") { result in
            if result.count != 0 {
                print (result[0])
                self.logPost = result
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //
}
