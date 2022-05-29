// 
//  RecoveryView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI
import FirebaseAuthUI

struct RecoveryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var loginVM = LoginModel()
    @FocusState private var inputFocus: Bool
    
    var body: some View {
        VStack {
            ZStack {
                // place a blue/purple ish gradient in the back stack
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 15) {
                    Spacer()
                    Text("Recover Password")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    TextField("email adress or phone number", text: $loginVM.userEmail)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    Button {
                        // Attempt to send reset password link via FirebaseAuth with provided email address
                        inputFocus.toggle()
                        guard FUIAuthBaseViewController.isValidEmail(loginVM.userEmail) else {
                            return;
                        }
                        loginVM.resetPassword() { res in
                            // dimiss if attemp successful, else nothing since a error should've popped up
                            if res {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Send Reset Instructions")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 60)
                            .background(Color.red)
                            .cornerRadius(30.0)
                    }
                    .padding(.bottom, 10)
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }
        .alert(item: $loginVM.error) { err in
            // Present alert to notify recovery failure, possible due to invalid email address
            Alert(title: Text(err.rawValue), message: Text("Password recovery failed, Please try again."))
        }
    }
}

struct RecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryView()
    }
}
