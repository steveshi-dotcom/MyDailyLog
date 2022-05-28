//
//  ProfilePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var profileVM = ProfileModel()
    @EnvironmentObject var loggedIn: Authentification
    @State private var showLoadingError: Bool = false
    @State private var showSignOutError: Bool = false
    
    @State private var image: Image = Image("noah-eleazar-9p6R1IDCXNg-unsplash")
    
    init() {
        profileVM.getUserInfo() { result in
            if !result {
                
            }
        }
        profileVM.getTotalLogCount()
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if profileVM.userInfo != nil {
                    Image(uiImage: UIImage(data: profileVM.userInfo!.userImage)!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(height: 300, alignment: .center)
                } else {
                    Image("skyler-ewing-Djneft6JzNM-unsplash")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(height: 250, alignment: .center)
                }
                Text(profileVM.userInfo?.userName ?? "Anonoumous Panda")
                    .font(.title)
                Text("Total Logs Filed: \(profileVM.totalLogCount)")
                    .font(.title)
                Spacer()
            }
            .toolbar {
                Button("Sign Out") {
                    LoginManager.shared.signOut { result in
                        print(result)
                        if !result {
                            showSignOutError = true
                        } else {
                            loggedIn.isValidated = false
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showLoadingError) {
            Alert(title: Text("Loading Profile Error"), message: Text("Unexpected error occured while loading your profile, please try again later."))
        }
        .alert(isPresented: $showSignOutError) {
            Alert(title: Text("Sign Out Error"), message: Text("Unexpected error occured while signing out, please try again later."))
        }
    }
    
    func add() {
        DatabaseManager.shared.getLogs(withEmail: "st3v5.s2i@gmail.com") { result in
            print("Finished")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
