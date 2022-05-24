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
        //        NavigationView {
        //            List(homeVM.logPost) { log in
        //                NavigationLink {
        //                    LogDisplayView(currLog: log)
        //                } label: {
        //                    HStack(spacing: 20) {
        //                        if UIImage(data: log.headerImageUrl) != nil {
        //                            Image(uiImage: UIImage(data: log.headerImageUrl)!)
        //                                .resizable()
        //                                .frame(width: 160, height: 200)
        //                                .scaledToFill()
        //                                .cornerRadius(6)
        //                                .background(.primary)
        //                                .cornerRadius(10)
        //                        } else {
        //                            Image("skyler-ewing-Djneft6JzNM-unsplash")
        //                                .resizable()
        //                                .scaledToFill()
        //                                .frame(width: 200, height: 200)
        //                                .cornerRadius(6)
        //                                .padding(2)
        //                                .background(.primary)
        //                                .cornerRadius(10)
        //                        }
        //                        VStack(alignment: .center, spacing: 10) {
        //                            Text(NSDate(timeIntervalSince1970: log.timeStamp) as Date, style: .date)
        //                                .cornerRadius(12.5)
        //                                .padding()
        //                                .cornerRadius(10)
        //                                .border(.blue, width: 5)
        //                            Text(log.headerImageCap)
        //                        }.padding(.bottom, 15)
        //                    }
        //                }
        //            }
        //            .refreshable {
        //                print("Refreshing")
        //                homeVM.loadLogs() { result in
        //                    if !result {
        //                        showLoadingAlert.toggle()
        //                    }
        //                }
        //            }
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
