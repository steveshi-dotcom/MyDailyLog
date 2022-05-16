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
                
                Button("Next Log", role: .none) {
                    nextLog()
                }
                
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
