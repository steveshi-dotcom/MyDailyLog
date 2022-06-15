//
//  ProfilePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

// A plain profile view where user can see their profile pic, name and total # of logs filed
struct ProfileView: View {
    @ObservedObject private var profileVM = ProfileModel()
    @EnvironmentObject var loggedIn: Authentification
    @State private var showLoadingError = false
    @State private var showSignOutError = false
    
    @State private var image: Image = Image("noah-eleazar-9p6R1IDCXNg-unsplash")
    
    init() {
        // Attempt to get all the information for the profileView when the user first gets in
        profileVM.getUserInfo() { res in
            if !res {
                print("ProfileView(Loading user profile): \(res)")
            }
        }
        // Obtain total logs filed
        profileVM.getTotalLogCount()
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image placeholder if image is not yet loaded from Firebase Storage
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
                        .frame(height: 300, alignment: .center)
                }
                Text(profileVM.userInfo?.userName ?? "Anonoumous Panda")
                    .font(.title)
                Text("Total Logs Filed: \(profileVM.totalLogCount)")
                    .font(.title)
                Spacer()
            }
            .toolbar {
                // Top right handcorner btn allowing user to sign out and go back to login page
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
            // Present any error while loading the profile page
            Alert(title: Text("Loading Profile Error"), message: Text("Unexpected error occured while loading your profile, please try again later."))
        }
        .alert(isPresented: $showSignOutError) {
            // Present any error while attempting to sign out of the account
            Alert(title: Text("Sign Out Error"), message: Text("Unexpected error occured while signing out, please try again later."))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
