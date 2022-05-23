//
//  HomePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeVM = HomeModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HomeTopView(currUser: homeVM.username)
                ScrollView {
                    Text("What")
                    Text("Hello")
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
