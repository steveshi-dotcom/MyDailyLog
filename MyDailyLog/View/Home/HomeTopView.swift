//
//  HomeTopView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import SwiftUI
import FirebaseAuth

struct HomeTopView: View {
    var currUser = Auth.auth().currentUser?.displayName
    var colWidth = UIScreen.main.bounds.width / 3
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(colWidth)), GridItem(.fixed(colWidth)),
                   GridItem(.fixed(colWidth))]) {
            Text("My DailyLog")
                .font(.system(size: 21))
                .fontWeight(.medium)
            Spacer()
            Text(currUser ?? "Anon.Panda")
        }.padding()
    }
}

struct HomeTopView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopView()
    }
}
