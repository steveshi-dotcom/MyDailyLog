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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Auth.auth().signIn(withEmail: credentials.username, password: credentials.password) {result, error in
                if let _ = error {
                    completion(.failure(.invalidCredentials))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    // Resetting the password for the provided email adress
    func resetPassword(email: String,
                       resetCompletion: @escaping (Result<Bool, Authentification.AuthentificationError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let _ = error {
                print("Error")
                resetCompletion(.failure(.failedRecovery))
            } else {
                print("Sucess")
                resetCompletion(.success(true))
            }
        })
    }
    
    // Signing up for an account with the provided information
    func signUp(withEmail email: String, withPassword password: String,
                completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let iError = error {
                    completion(.failure(iError))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    //
}
