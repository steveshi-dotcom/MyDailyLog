//
//  HomePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeVM = HomeModel()
    @State private var showLoadingAlert: Bool = false
    
    let column = [GridItem(.flexible(minimum: 175, maximum: 175)),
                  GridItem(.flexible(minimum: 175, maximum: 175))]
    
    init() {
        // load all logs captured on start
        homeVM.loadLogs { res in
            print("HomeView(Loading all log): \(res)")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 30) {
                    // Two column grid where each row has two logPost that a user posted with the date
                    ForEach(homeVM.logPost) { log in
                        NavigationLink(destination: LogDisplayView(currLog: log), label: {
                            ZStack {
                                if UIImage(data: log.headerImageUrl) != nil {
                                    Image(uiImage: UIImage(data: log.headerImageUrl)!)
                                        .resizable()
                                        .frame(width: 175, height: 215)
                                        .scaledToFill()
                                        .cornerRadius(6)
                                        .background(.primary)
                                        .cornerRadius(10)
                                }
                                VStack(alignment: .trailing) {
                                    Spacer()
                                    Text(NSDate(timeIntervalSince1970: log.timeStamp) as Date, style: .date)
                                        .font(.title2)
                                }
                            }
                        })
                    }
                }
                .refreshable { // Allow user to refresh the page to load up all logs // Not working
                    homeVM.loadLogs() { result in
                        if !result {
                            showLoadingAlert.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Logs")
        }
        .alert(isPresented: $showLoadingAlert) {
            // Present any error while pulling logs posted by user from FireBase
            Alert(title: Text("Error pulling all logs"), message: Text("Plese try again later"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
