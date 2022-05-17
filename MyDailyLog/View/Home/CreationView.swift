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
                add()
            }
        }
    }
    func add() {

    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
