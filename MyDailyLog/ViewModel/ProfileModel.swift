//
//  ProfileModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class ProfileModel: ObservableObject {
    //
    
    let db = Firestore.firestore()
    private init() { }
    
    func returnUserName(completion: @escaping (Result<String, DatabaseManager.FireStoreError>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        db
            .collection("user")
            .document(email)
            .collection("userInfo")
            .document("Info")
            .getDocument() { snapshot, err in
                if err != nil {
                    completion(.failure(.failedRetrieval))
                } else {
                    completion(.success(snapshot.map(String.init(describing: )) ?? "nil"))
                }
            }
    }
}
