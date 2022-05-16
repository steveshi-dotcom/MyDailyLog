//
//  LoginService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginService {
    static let shared = LoginService()
 
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Auth.auth().signIn(withEmail: credentials.username, password: credentials.password) {result, error in
                if error != nil {
                    completion(.failure(.invalidCredentials))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
}
