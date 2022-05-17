//
//  HomePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 10) {
                    Text("My DailyLog")
                    Spacer()
                }
                Spacer()
                Spacer()
            }
        }
    }
    
    func nextLog() {
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
