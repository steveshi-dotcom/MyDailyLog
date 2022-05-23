//
//  HomePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeVM = HomeModel()
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    init() {
        homeVM.getName()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(homeVM.logPost) { log in
                        NavigationLink {
                            LogDisplayView()
                        } label: {
                            VStack {
                                Image("")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                Text("\(log.timeStamp)")
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                
            }
            .navigationTitle("Logs")
            .preferredColorScheme(.dark)
            
        }
        //        NavigationView {
        //            VStack {
        //                HomeTopView(currUser: "Steve")//homeVM.username)
        //                ScrollView {
        //                    ForEach(0..<homeVM.logPost.count, id: \.self) { ind in
        //
        //                    }
        //                }
        //            }
        //        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
