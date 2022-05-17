//
//  CreationPage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct CreationView: View {
    @State private var userText: String = ""
    var body: some View {
        VStack {
            TextField("Word", text: $userText)
            Button("Add") {
                createLog()
            }
        }
    }
    func createLog() {
        let newLog = Log(id: UUID().uuidString, timeStamp: Date().timeIntervalSince1970, headerImageUrl: nil, text: userText)
        
        
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
