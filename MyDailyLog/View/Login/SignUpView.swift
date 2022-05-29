//
//  SignUpView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import SwiftUI
import FirebaseAuthUI
import Inject

struct SignUpView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var loginM = LoginModel()
    @FocusState private var inputFocus: Bool
    
    @State private var signupName = ""
    @State private var signupEmail = ""
    @State private var signupPswd = ""
    @State private var signupPswdConfirm = ""
    @State private var insufficientInputAlert = false
    @State private var showingCameraPicker = false
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 15) {
                    Spacer()
                    Text("Let's get started!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    HStack {
                        // Present a placeholder puppy pic until user take a profile picture for use
                        if loginM.profilePic.count != 0 {
                            Image(uiImage: loginM.profilePic[0])
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(height: 200, alignment: .center)
                                .padding(1)
                        } else {
                            Image("skyler-ewing-Djneft6JzNM-unsplash")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(height: 200, alignment: .center)
                        }
                    }
                    .onTapGesture {
                        // Toggle camera picker for user to take picture
                        showingCameraPicker.toggle()
                    }
                    TextField("name", text: $signupName)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(7.5)
                        .padding(.bottom, 5)
                    TextField("email address", text: $signupEmail)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(7.5)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 5)
                    SecureField("password", text: $signupPswd)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(7.5)
                        .autocapitalization(.none)
                        .padding(.bottom, 5)
                    SecureField("confirm password", text: $signupPswdConfirm)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(7.5)
                        .autocapitalization(.none)
                        .padding(.bottom, 5)
                    Button {
                        // Attempt to signup with the provided information and if successful dimiss signup sheet
                        inputFocus = false
                        guard signupPswd == signupPswdConfirm && FUIAuthBaseViewController.isValidEmail(signupEmail) && loginM.profilePic.count != 0 else {
                            insufficientInputAlert.toggle()
                            return
                        }
                        loginM.signup(withName: signupName, withEmail: signupEmail, withPassword: signupPswd, withProfilePic: loginM.profilePic[0].jpegData(compressionQuality: 0.8)) { res in
                            // dimiss if attemp successful, else a error should've popped up from backend
                            if res {
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
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }
        .alert(item: $loginM.error) { err in
            // Present signup error if any from loginViewModel
            Alert(title: Text(err.rawValue), message: Text("Account signup failed, please try again."))
        }
        .alert(isPresented: $insufficientInputAlert) {
            // Present insufficent information error if user did not input all information
            Alert(title: Text("Registration Error"), message: Text("Please double check the input fields to make sure they are inputted and correct."))
        }
        .sheet(isPresented: $showingCameraPicker) {
            // Present a camera view for user to take image and use it for profile pic
            CreationCameraPickerView(isPresented: $showingCameraPicker) {
                loginM.handleAddedImage($0)
            }
        }
        .enableInjection()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
