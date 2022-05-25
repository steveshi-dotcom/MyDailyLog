//
//  ProfileModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class ProfileModel: ObservableObject {
    @Published var userInfo: User?
    
    let db = Firestore.firestore()
    
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db
            .collection("user")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .getDocument() { snapshot, err in
                if err != nil {
                    completion(false)
                } else {
                    
                    completion(true)
                }
            }
    }

    
    
}
