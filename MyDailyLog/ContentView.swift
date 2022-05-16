//
//  ContentView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var authenticated: Bool = false
    var body: some View {
        if authenticated {
            LoginView()
        } else {
            NavigationView {
                Group {
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
                            }
                    }
                    .tabViewStyle(.automatic)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
