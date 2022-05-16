//
//  MyDailyLogApp.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Firebase

@main
struct MyDailyLogApp: App {
    @StateObject var authentification = Authentification()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if authentification.isValidated {
                ContentView()
                    .environmentObject(authentification)
            } else {
                LoginView()
                    .environmentObject(authentification)
            }
        }
    }
}
