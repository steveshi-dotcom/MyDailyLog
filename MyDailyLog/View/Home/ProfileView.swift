//
//  ProfilePage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct ProfileView: View {
    @State private var image: Image = Image("noah-eleazar-9p6R1IDCXNg-unsplash")
    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: 200, height: 200)
            Button(role: .none) {
                add()
            } label: {
                Label("jsdflasdfkj", systemImage: "alarm")
            }
        }
    }
    
    func add() {
        DatabaseManager.shared.getLogs(withEmail: "st3v5.s2i@gmail.com") { result in
            print("Finished")
        }
//        StorageManager.shared.getLogHeaderImage(withPath: "images/st3v5_s2i_gmail_com/46021F1A-CA5D-4889-B049-0FB2C4AEE129.jpg") { (result: Result<UIImage, StorageManager.StorageError>) in
//            switch result {
//            case .success(let iImage):
//                image = Image(uiImage: iImage)
//            case .failure:
//                print("asfdi")
//            }
//        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
