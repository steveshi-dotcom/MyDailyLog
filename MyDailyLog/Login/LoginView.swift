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
                    .autocapitalization(.none)
                    .foregroundColor(.primary)
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(.black)
                    .cornerRadius(5.0)
                    .focused($focusState)
                HStack {
                    Spacer()
                    Button(action: forgotPassword) {
                        Text("Forgot password?")
                    }
                }
                Button {
                    guard !username.isEmpty && !password.isEmpty else {
                        print("Empty credentials")
                        return
                    }
                    attemptLogin()
                    focusState.toggle()
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                        .background(Color.blue)
                        .cornerRadius(30.0)
                }
                .padding(.bottom, 10)
                labelledDivider(label: "or")
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
    func loginFailure() {   // Move to ContentView
        
    }
    func loginSucess() {    // Stay on LoginView
        
    }
    func forgotPassword() { // Move to RecoveryView
        
    }
}

struct labelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    
    init(label: String, horizontalPadding: CGFloat = 10, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    
    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }
    var line: some View {
        VStack {
            Divider().background(color)
        }.padding(horizontalPadding)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
