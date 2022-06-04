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
    @State private var showWelcome: Bool = true
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView().onAppear {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { showWelcome = false }
                }
            } else {
                VStack {
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
    }
}
