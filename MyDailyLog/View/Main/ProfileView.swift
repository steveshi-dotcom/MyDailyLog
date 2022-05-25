//
//  ProfilePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var profileVM = ProfileModel()
    
    @State private var image: Image = Image("noah-eleazar-9p6R1IDCXNg-unsplash")
    
    init() {
        profileVM.getUserInfo() { result in
            
        }
    }
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: profileVM.userInfo!.userImage)!)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(100)
            Text(profileVM.userInfo?.userName ?? "Anonomous.Panda")
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
