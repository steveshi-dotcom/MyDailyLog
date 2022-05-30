//
//  EntryService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    // FireStore Error for reference in case failed operation
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
        
        // Doc data under the log collection for each log post
        let data: [String: Any] = [
            "id": log.id,
            "timestamp": log.timeStamp,
            "headerImageCap": log.headerImageCap,
            "bodyText": log.bodyText,
            "imagePath": "images/\(replacedEmail)/\(log.id).jpg"
        ]
        
        // Create the document under the logs collection for the specified email and add the data
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document(log.id)
            .setData(data) { err in
                if err == nil {
                    // After uploading the log data to FireStore, upload the logImage to Storage
                    StorageManager.shared.uploadLogHeaderImage(log: log, withEmail: replacedEmail) {(res: Result<Bool, StorageManager.StorageError>) in
                        switch res {
                        case .success:
                            completion(true)
                        case .failure(let iError):
                            print("Error uploading image \(iError.rawValue)")
                            completion(false)
                        }
                    }
                } else {
                    completion(false)
                }
            }
    }
    
    // Obtain all the logs for an specific user within Firestore, as well as retrieve each log post image
    // for each individual logs from Firebase Storage
    func getLogs(withEmail email: String, completion: @escaping ([Log]) -> Void) {
        var retrievedLogs: [Log] = []
        let replacedEmail = refractorEmail(withEmail: email)
        
        // Obtain every log post from log collection, and obtain image for each of the log post and append it to retrievedLogs
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting the documents: \(err.localizedDescription)")
                    completion([])
                } else {
                    for document in querySnapshot!.documents {
                        if document.documentID != "userMetaData" {  // ignore userMetaData doc within snapshot
                            let data = document.data()
                            
                            // Find the image path and attempt to retrive log image and create the log obj for retrievedLog
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
                                    let retrievedLog = Log(id: id, timeStamp: timeStamp, headerImageUrl: iImage.jpegData(compressionQuality: 0.8)!, headerImageCap: headerImageCap, bodyText: bodyText)
                                    retrievedLogs.append(retrievedLog)
                                    print(retrievedLog.bodyText)
                                case .failure(let iError):
                                    print("Failed to retrived an image: \(iError.rawValue)")
                                }
                            }
                        }
                    }
                }
            }
        // TODO: Completion closure after retrieve all the logs under log collection...
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion(retrievedLogs)
        }
    }
    
    // Insert the user by adding the email and create the log doc with userMetaData along with other logs
    func insertUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = refractorEmail(withEmail: user.userEmail)
        
        // Insert the userMeta data under the logs Collection
        let profilePicPath = "images/\(replacedEmail)/userPic"
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .setData(["userName": user.userName,
                      "userEmail": user.userEmail,
                      "userPicPath": profilePicPath]) { err in
                if err == nil {
                    // If successfully uploaded userMetadata, then add the image with the path specified in userMetaData doc
                    StorageManager.shared.uploadUserPic(withImage: user.userImage, withPath: profilePicPath) {(result: Result<Bool, StorageManager.StorageError>) in
                        switch result {
                        case .success:
                            completion(.success(true))
                        case .failure(let iError):
                            print("Error uploading userPic: \(iError.rawValue)")
                            completion(.failure(.failedUpload))
                        }
                    }
                } else {
                    completion(.failure(.failedUpload))
                }
            }
    }
    
    // Delete the user by deleting the email document within users from firestore // TODO: delete image for user
    func deleteUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = refractorEmail(withEmail: user.userEmail)
        // delete the replacedEmail field within users collection to delete everything for that specific user
        db.collection("users")
            .document(replacedEmail)
            .delete() { err in
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
        
        //TODO: Need to delete every image in FireBase Storage after deleting the email from collection
    }
    
    // Obtain the User from FireBase
    func getUser(withEmail email: String, completion: @escaping (Result<User, FireStoreError>) -> Void) {
        let replacedEmail = refractorEmail(withEmail: email)
        
        // Find the userName from FireStore and user the imagePath from the doc to find the image in Storage
        db.collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .getDocument { snapshot, err in
                if let data = snapshot?.data() {
                    let name = data["userName"] as! String
                    let email = data["userEmail"] as! String
                    
                    // Use the imagePath to retrieve profile pic from Firebase Storage
                    let imagePath = data["userPicPath"] as! String
                    StorageManager.shared.getLogHeaderImage(withPath: imagePath) { (result: Result<UIImage, StorageManager.StorageError>) in
                        switch result {
                        case .success(let image):
                            let userInfo = User(userName: name, userEmail: email, userImage: image.jpegData(compressionQuality: 0.8)!)
                            completion(.success(userInfo))
                        case .failure:
                            completion(.failure(.failedRetrieval))
                        }
                    }
                } else {
                    completion(.failure(.failedRetrieval))
                }
            }
    }
    
    // Refractor the email string, replacing '.' + '@' with '_',
    // Ex: Bob.Builder@gmail.com => Bob_Builder_gmail_com
    func refractorEmail(withEmail email: String) -> String {
        email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
    }
    
}
