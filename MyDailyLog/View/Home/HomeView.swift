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
        homeVM.loadLogs { result in
            print(result)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: column, spacing: 20) {
                    ForEach(homeVM.logPost) { log in
                        NavigationLink(destination: LogDisplayView(currLog: log), label: {
                            ZStack {
                                if UIImage(data: log.headerImageUrl) != nil {
                                    Image(uiImage: UIImage(data: log.headerImageUrl)!)
                                        .resizable()
                                        .frame(width: 160, height: 200)
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
                    .refreshable {
                        print("Refreshing")
                        homeVM.loadLogs() { result in
                            if !result {
                                showLoadingAlert.toggle()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Logs")
        }
        .alert(isPresented: $showLoadingAlert) {
            Alert(title: Text("Error pulling all logs"), message: Text("Plese try again later"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
