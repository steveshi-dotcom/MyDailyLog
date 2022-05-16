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
    
    // Loggin in with the provided credentials
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        Auth.auth().signIn(withEmail: credentials.username, password: credentials.password) {result, error in
            if let _ = error {
                completion(.failure(.invalidCredentials))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // Resetting the password for the provided email adress
    func resetPassword(email: String,
                       resetCompletion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let _ = error {
                resetCompletion(.failure(.failedRecovery))
            } else {
                resetCompletion(.success(true))
            }
        })
    }
    
    // Signing up for an account with the provided information
    func signUp(withEmail email: String, withPassword password: String,
                completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let _ = error {
                completion(.failure(.signupFailure))
            } else {
                completion(.success(true))
            }
        }
    }
}
