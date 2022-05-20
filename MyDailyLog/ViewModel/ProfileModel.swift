//
//  ProfileModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class ProfileModel: ObservableObject {
    @Published var username: String = ""
    
    let db = Firestore.firestore()
    private init() { }
    
    func returnUserName(completion: @escaping (Result<String, DatabaseManager.FireStoreError>) -> Void) {
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
                    completion(.failure(.failedRetrieval))
                } else {
                    completion(.success(snapshot.map(String.init(describing: )) ?? "nil"))
                }
            }
    }
}
