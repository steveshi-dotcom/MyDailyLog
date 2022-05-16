//
//  Authentification.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

class Authentification: ObservableObject {
    @Published var isValidated: Bool = false
    
    func updateValidation(_ success: Bool) {
        withAnimation {
            isValidated = success
        }
        print(isValidated)
    }
}
