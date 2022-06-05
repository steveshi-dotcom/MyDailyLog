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
    @State private var refresh: Bool = false
    
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
                PullToRefreshSwiftUI(needRefresh: $refresh,
                                     coordinateSpaceName: "pullToRefresh") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            refresh = false
                            homeVM.loadLogs { res in
                                print("HomeView(Loading all log): \(res)")
                            }
                        }
                    }
                }
                LazyVGrid(columns: column, spacing: 10) {
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
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(5)
                                        .foregroundColor(.white)
                                        .background(.black)
                                        .cornerRadius(20)
                                }
                            }
                        })
                    }
                }
            }
            .coordinateSpace(name: "pullToRefresh")
            .navigationTitle("Logs")
        }
        //        .alert(isPresented: $showLoadingAlert) {
        //            // Present any error while pulling logs posted by user from FireBase
        //            Alert(title: Text("Error pulling all logs"), message: Text("Plese try again later"))
        //        }
    }
}

struct PullToRefreshSwiftUI: View {
    @Binding private var needRefresh: Bool
    private let coordinateSpaceName: String
    private let onRefresh: () -> Void
    
    init(needRefresh: Binding<Bool>, coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self._needRefresh = needRefresh
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if needRefresh {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 100)
            }
        }
        .background(GeometryReader {
            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self,
                                   value: $0.frame(in: .named(coordinateSpaceName)).origin.y)
        })
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offset in
            guard !needRefresh else { return }
            if abs(offset) > 50 {
                needRefresh = true
                onRefresh()
            }
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
