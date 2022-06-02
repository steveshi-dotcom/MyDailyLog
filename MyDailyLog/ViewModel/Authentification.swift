//
//  Authentification.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

class Authentification: ObservableObject {
    @Published var isValidated: Bool = false
    
    init() {
//        let uLogin = UserDefaults.standard.bool(forKey: "uLogin")
//        if uLogin {
//            if let uCredentials: [String:String] = UserDefaults.standard.data(forKey: "uCredentials") as? [String: String] {
//                LoginManager.shared.login(withEmail: uCredentials["email"]!, withPassword: uCredentials["password"]!) { [unowned self](result: Result<Bool, AuthentificationError>) in
//                    isValidated = true
//                }
//            }
//        }
    }
    // List of authentification errors used for login/logout purposes
    enum AuthentificationError: String, Error, LocalizedError, Identifiable {
        case invalidCredentials = "Email or Password Incorrect"
        case failedPasswordRecovery = "Password Recovery Failed"
        case failedAccountSignUp = "Account SignUp Failed"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    // Update the current state of the user validation
    func updateValidation(_ success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
