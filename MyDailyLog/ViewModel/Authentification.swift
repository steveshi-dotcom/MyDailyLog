//
//  Authentification.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

class Authentification: ObservableObject {
    @Published var isValidated: Bool = true
    
    enum AuthentificationError: String, Error, LocalizedError, Identifiable {
        case invalidCredentials = "Email or Password Incorrect"
        case failedPasswordRecovery = "Password Recovery Failed"
        case failedAccountSignUp = "Account SignUp Failed"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    func updateValidation(_ success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
