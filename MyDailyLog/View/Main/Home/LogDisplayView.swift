//
//  LogDisplayView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/23/22.
//

import SwiftUI

// Nav view showing each specific log post based on the logImage the user clicked on in HomeView
struct LogDisplayView: View {
    let currLog: Log
    
    var body: some View {
        NavigationView {
            // Two row with the top row containing two columns showing the image plus the caption on the right
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(190), spacing: 8), count: 2)) {
                    ZStack(alignment: .center) {
                        Image(uiImage: UIImage(data: currLog.headerImageUrl)!)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(12.5)
                    }
                    Text(currLog.headerImageCap)
                        .cornerRadius(12)
                        .multilineTextAlignment(.center)
                        .frame(width: 175, height: 150)
                        .padding(.trailing, 10)
                }
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.cyan]), startPoint: .leading, endPoint: .trailing)
                    Text(currLog.bodyText)
                        .cornerRadius(12.5)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2 - 20)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .border(Color(UIColor.systemCyan), width: 10)
                .cornerRadius(12.5)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .navigationTitle("\(currLog.timeStamp)")
            .navigationBarHidden(true)
        }
    }
}
