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
    @Published var totalLogCount = 0
    
    let db = Firestore.firestore()
    
    func getTotalLogCount() {
        guard let email = Auth.auth().currentUser?.email else {
            totalLogCount = -1
            return
        }
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .getDocuments { snapshots, err in
                if err == nil {
                    self.totalLogCount = snapshots!.count - 1
                } else {
                    self.totalLogCount = -1
                }
            }
    }
    
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        DatabaseManager.shared.getUser(withEmail: replacedEmail) { result in
            switch result {
            case .success(let user):
                print("---------Success---------")
                self.userInfo = user
            case .failure(let err):
                print(err.rawValue)
                completion(false)
            }
        }
    }
    
    
    
}
