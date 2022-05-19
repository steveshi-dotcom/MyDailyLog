//
//  SignUpView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import SwiftUI
import FirebaseAuthUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var loginM = LoginModel()
    @FocusState private var inputFocus: Bool
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordAlert: Bool = false
    @State private var showRecoveryAlert: Bool = false
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 15) {
                    Spacer()
                    Text("Register for an account")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    TextField("email address", text: $newEmail)
                        .padding()
                        .background(lightGreyColor)
                        .foregroundColor(.black)
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    SecureField("password", text: $newPassword)
                        .padding()
                        .background(lightGreyColor)
                        .foregroundColor(.black)
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    SecureField("confirm password", text: $confirmPassword)
                        .padding()
                        .background(lightGreyColor)
                        .foregroundColor(.black)
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    Button {
                        inputFocus.toggle()
                        guard newPassword == confirmPassword && FUIAuthBaseViewController.isValidEmail(newEmail) else {
                            showPasswordAlert.toggle()
                            return
                        }
                        loginM.signup(withEmail: newEmail, withPassword: newPassword) { result in
                            if result {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Sign up for MyDailyLog")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 60)
                            .background(Color.blue)
                            .cornerRadius(30.0)
                    }
                    .padding(.bottom, 10)
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }
        .alert(item: $loginM.error) {error in
            Alert(title: Text(error.rawValue),message: Text(Authentification.AuthentificationError.invalidCredentials.errorDescription ?? "Account signup failed, please try again."))
        }
        .alert(isPresented: $showPasswordAlert) {
            Alert(title: Text("Registration Error"), message: Text("Please double check the input fields to make sure they are correct."))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}