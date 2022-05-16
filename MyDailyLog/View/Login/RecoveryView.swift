//
//  RecoveryView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import SwiftUI

struct RecoveryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var loginM = LoginModel()
    @State private var recoverEmail: String = ""
    @State private var showRecoveryAlert: Bool = false
    @FocusState private var focusState: Bool
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 15) {
                    Spacer()
                    Text("Recover Password")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    TextField("email adress or phone number", text: $recoverEmail)
                        .padding()
                        .background(lightGreyColor)
                        .foregroundColor(.black)
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    Button {
                        focusState.toggle()
                        loginM.resetPassword(withEmail: recoverEmail) { result in
                            if result {
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
        .alert(item: $loginM.error) {error in
            Alert(title: Text("Recovery Failed"),message: Text(Authentification.AuthentificationError.invalidCredentials.errorDescription ?? "Password recovery failed, Please try again."))
        }
    }
}

struct RecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryView()
    }
}
