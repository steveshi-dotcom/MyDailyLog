//
//  Authentification.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

class Authentification: ObservableObject {
    @Published var isValidated: Bool = false
    
    enum AuthentificationError: String, Error, LocalizedError, Identifiable {
        case invalidCredentials = "Email or Password inccorect, Please try again."
        case failedRecovery = "Password recovery failed"
        case signupFailure = "Account signup failed"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    func updateValidation(_ success: Bool) {
        withAnimation {
            isValidated = success
        }
        print(isValidated)
    }
}
