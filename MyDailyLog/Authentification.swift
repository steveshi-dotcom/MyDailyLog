//
//  Authentification.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

class Authentification: ObservableObject {
    @Published var isValidated: Bool = false
    
    enum AuthentificationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        
        var id: String {
            self.localizedDescription
        }
        var errorDescription: String? {
            return NSLocalizedString("Email or Password inccorect, Please try again", comment: "")
        }
    }
    
    func updateValidation(_ success: Bool) {
        withAnimation {
            isValidated = success
        }
        print(isValidated)
    }
}
