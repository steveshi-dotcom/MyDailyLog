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
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    init() {
        //homeVM.getName()
    }
    
    var body: some View {
        NavigationView {
            List(homeVM.logPost) { log in
                NavigationLink {
                    LogDisplayView()
                } label: {
                    VStack {
                        if UIImage(data: log.headerImageUrl) != nil {
                            Image(uiImage: UIImage(data: log.headerImageUrl)!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                        } else {
                            Image("skyler-ewing-Djneft6JzNM-unsplash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                        }
                        Text("\(log.timeStamp)")
                    }
                }
            }
            .refreshable {
                print("Refreshing")
                homeVM.loadLogs() { result in
                    if !result {
                        showLoadingAlert.toggle()
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
