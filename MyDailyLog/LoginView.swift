//
//  LoginView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focusState: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 15) {
                Spacer()
                Text("My Daily Log")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                TextField("email adress or phone number", text: $username)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(.black)
                    .cornerRadius(5.0)
                    .padding(.bottom, 7.5)
                    .padding(.top, 5)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(.black)
                    .cornerRadius(5.0)
                    .padding(.bottom, 7.5)
                    .focused($focusState)
                HStack(alignment: .top) {   // Make Forgot password btn on right edge
                    Text("Hello")
                    Button(action: forgotPassword) {
                        Text("Forgot password?")
                    }
                }
                
                Button("Log In") {
                    attemptLogin()
                    focusState.toggle()
                }.buttonStyle(.bordered)
                HStack {
                    Text("Or")
                }
                Spacer()
                Spacer()
            }
            .padding()
        }
    }
    
    func attemptLogin() {
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if error != nil {
                print("Invalid credentials")
                loginFailure()
            } else {
                print("Valid credentials")
                loginSucess()
            }
        }
    }
    func loginFailure() {
        
    }
    func loginSucess() {
        
    }
    func forgotPassword() {
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
