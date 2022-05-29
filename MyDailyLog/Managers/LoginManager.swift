//
//  LoginService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import FirebaseAuth

class LoginManager {
    static let shared = LoginManager()
    private let auth = Auth.auth()
    
    private init() {}
    
    // Loggin in with the provided credentials
    func login(withEmail email: String, withPassword password: String,
               completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        auth.signIn(withEmail: email, password: password) { res, err in
            if let _ = err {
                completion(.failure(.invalidCredentials))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // Resetting the password for the provided email adress
    func resetPassword(withEmail email: String,
                       completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        auth.sendPasswordReset(withEmail: email, completion: { err in
            if let _ = err {
                completion(.failure(.failedPasswordRecovery))
            } else {
                completion(.success(true))
            }
        })
    }
    
    // Signing up for an account with the provided information
    func signUp(withEmail email: String, withPassword password: String,
                completion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        auth.createUser(withEmail: email, password: password) { res, err in
            if let _ = err {
                completion(.failure(.failedAccountSignUp))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // Sign out the user account
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print("Error signing out: \(error)")
            completion(false)
        }
    }
    
}
