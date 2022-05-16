//
//  LoginModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginModel: ObservableObject {
    @Published var credentials = Credentials()
    
    var disableLogin: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: credentials.username, password: credentials.password) { [unowned self] result, error in
            if error != nil {
                credentials = Credentials()
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
