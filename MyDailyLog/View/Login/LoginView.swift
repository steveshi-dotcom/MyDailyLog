//
//  LoginView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Firebase
import Inject

// Typical login screen for a standard app
// User will input email + password to login to their account
// User will have option recover password, signup for new account
struct LoginView: View {
    @ObserveInjection var inject
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var loginVM = LoginModel()
    @EnvironmentObject var authentification: Authentification
    @FocusState private var focusState: Bool
    @State private var showRecoverySheet = false
    @State private var showSignUpSheet = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack(alignment: .center, spacing: 15) {
                    Spacer()
                    Text("My Daily Log")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 6)
                    TextField("Email adress", text: $loginVM.userEmail)
                        .font(.headline)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                            .strokeBorder(colorScheme == .dark ? .white : .black, style: StrokeStyle(lineWidth: 1.0)))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $loginVM.userPassword)
                        .font(.headline)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                            .strokeBorder(colorScheme == .dark ? .white : .black, style: StrokeStyle(lineWidth: 1.0)))
                        .focused($focusState)
                    HStack {
                        Spacer()
                        Button("Forgot password") {
                            showRecoverySheet  = true
                        }
                    }
                    Button {
                        // LoginBtn to attempt to login with their inputted credentials
                        focusState = false
                        loginVM.login() { result in
                            if result {
                                
                            }
                            authentification.updateValidation(result)
                        }
                    } label: {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 60)
                            .background(.blue)
                            .cornerRadius(30.0)
                    }
                    .padding(.bottom, 10)
                    labelledDivider(label: "OR")    // A divider view with 'OR' in the middle
                    Button {
                        // Toggle SignUpSheet view for user to make an account
                        showSignUpSheet = true
                    } label: {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 60)
                            .background(.purple)
                            .cornerRadius(30.0)
                    }
                    Spacer()
                    Spacer()
                }
                .padding()
            }
            .alert(item: $loginVM.error) { err in
                // Alert authentification error that pops up while loging in
                Alert(title: Text(err.rawValue),
                      message: Text("Double check to make sure the email/password is correct"))
            }
        }
        .sheet(isPresented: $showRecoverySheet) {
            // Present sheet for user to enter their email address to reset password
            RecoveryView()
        }
        .sheet(isPresented: $showSignUpSheet) {
            // Present sheet for user to enter enter info(name, profilePic, email, password) to create account
            SignUpView()
        }
        
        .enableInjection()
    }
}

// An divider with text in the middle   -----??-----
struct labelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    
    init(label: String, horizontalPadding: CGFloat = 5) {
        self.label = label
        self.horizontalPadding = horizontalPadding
    }
    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(.black)
            line
        }
    }
    var line: some View {
        VStack {
            Divider().background(.black)
        }.padding(horizontalPadding)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
