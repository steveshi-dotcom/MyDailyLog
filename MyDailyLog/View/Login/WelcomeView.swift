//
//  WelcomeView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

// Welcome view when the user first open the app, title + shortDescription
struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("noah-eleazar-9p6R1IDCXNg-unsplash")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Text("My Daily Log")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Capture short snapshots and \nlog your day to day")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
