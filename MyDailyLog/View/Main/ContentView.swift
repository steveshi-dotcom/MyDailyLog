//
//  ContentView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Inject

struct ContentView: View {
    @ObserveInjection var inject
    @EnvironmentObject var loggedIn: Authentification
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CreationView()
                .tabItem() {
                    Label("New", systemImage: "plus")
                }
            ProfileView()
                .tabItem() {
                    Label("Profile", systemImage: "person")
                        .environmentObject(loggedIn)
                }
        }
        .tabViewStyle(.automatic)
        
        .enableInjection()
    }
}

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
