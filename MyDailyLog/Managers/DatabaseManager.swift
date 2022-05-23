//
//  EntryService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    enum FireStoreError: String, Error, LocalizedError, Identifiable {
        case failedUpload = "Failed to upload data to Firebase FireStore"
        case failedRetrieval = "Failed to retrieve data from Firebase FireStore"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    private init() {}
    
    // Insert the log info such as uuid, timestamp, body text, image caption within FireStore Database
    // and store the image in FireStorage since the file size would be too big. Ex: one image captured
    // with jpg compressed to 0.8 is roughly 1.95mb, could possibly make that smaller but would reduce quality
    func insertLog(log: Log, email: String, completion: @escaping (Bool) -> Void) {
        let replacedEmail = refractorEmail(withEmail: email)
        let data: [String: Any] = [
            "id": log.id,
            "timestamp": log.timeStamp,
            "headerImageCap": log.headerImageCap,
            "bodyText": log.bodyText,
            "imagePath": "images/\(replacedEmail)/\(log.id).jpg"
        ]
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document(log.id)
            .setData(data) { err in
                if err == nil {
                    StorageManager.shared.uploadLogHeaderImage(log: log, withEmail: replacedEmail) {(result: Result<Bool, StorageManager.StorageError>) in
                        switch result {
                        case .success:
                            completion(true)
                        case .failure(let iError):
                            print(iError.rawValue)
                            completion(false)
                        }
                    }
                } else {
                    completion(false)
                }
            }
    }
    
    // Obtain all the logs for an specific user within Firestore, as well as retrieve each log post image
    // for each individual logs from Firebase Storage   // TODO: Checkout Logic
    func getLogs(withEmail email: String, completion: @escaping ([Log]) -> Void) {
        var retrievedLogs: [Log] = []
        let replacedEmail = refractorEmail(withEmail: email)
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .getDocuments { querySnapshot, err in
                if let _ = err {
                    print("Error getting the documents")
                    completion([])
                } else {
                    for document in querySnapshot!.documents {
                        if document.documentID != "userMetaData" {
                            let data = document.data()
                            let imagePath = data["imagePath"] as? String
                            StorageManager.shared.getLogHeaderImage(withPath: imagePath!) { (result: Result<UIImage, StorageManager.StorageError>) in
                                switch result {
                                case .success(let iImage):
                                    guard let id = data["id"] as? String,
                                          let timeStamp = data["timestamp"] as? TimeInterval,
                                          let headerImageCap = data["headerImageCap"] as? String,
                                          let bodyText = data["bodyText"] as? String else {
                                        return
                                    }
                                    let retrievedLog = Log(id: id, timeStamp: timeStamp, headerImageUrl: iImage.jpegData(compressionQuality: 0.8)! , headerImageCap: headerImageCap, bodyText: bodyText)
                                    print(retrievedLog.bodyText)
                                    retrievedLogs.append(retrievedLog)
                                case .failure:
                                    print("Failed to retrived an image")
                                }
                            }
                        }
                    }
                    // Not sure how to asynchronously await until firebase storage retrieval is finished
                    // Run the completion method after 3 seconds ish, since it retrieval should be finished
                    // and let the client know the result // TODO: Figure out how to async wait top func
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        completion(retrievedLogs)
                    }
                }
            }
    }
    
    // Insert the user by adding the email and create the log doc with userMetaData along with other logs
    func insertUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = refractorEmail(withEmail: user.userEmail)
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .setData(["userName": user.userName, "userEmail": user.userEmail]) { err in // TODO: Figure out why using the user model won't work
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    // Delete the user by deleting the email document within users from firestore // TODO: delete image for user
    func deleteUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = refractorEmail(withEmail: user.userEmail)
        db.collection("users")
            .document(replacedEmail)
            .delete() { err in
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    // Obtain the username from firestore
    func getUser(withEmail email: String, completion: @escaping (String) -> Void) {
        let replacedEmail = refractorEmail(withEmail: email)
        db.collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .getDocument { snapshot, err in
                if let data = snapshot?.data() {
                    let name = data["userName"]
                    completion(name as! String)
                } else {
                    completion("John Smith")
                }
            }
    }
    
    // Refractor the email string, replacing '.' + '@' with '_'
    func refractorEmail(withEmail email: String) -> String {
        email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
    }
    
    ///
}
