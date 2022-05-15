//
//  LoginView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginBtn: Bool = false
    @State private var registerBtn: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("My Daily Log")
                .font(.system(size: 50))
                .fontWeight(.bold)
            TextField("username or email", text: $username)
                .border(.black , width: 1)
                .padding()
            TextField("password", text: $password)
                .border(.black , width: 1)
                .padding()

            Button("Login") {}
            Text("Or")
            Button("new? create an account") {}
            Spacer()
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
