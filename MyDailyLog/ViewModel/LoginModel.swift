//
//  LoginModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import Foundation
import PhotosUI

// LoginViewModel to keep track of the account state, such as username, password, profilepicture, etc
class LoginModel: ObservableObject {
    @Published var error: Authentification.AuthentificationError?
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var profilePic: [UIImage] = []
    
    var canTakePictures: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // UIImage that was takened from camera picker
    func handleAddedImage(_ image: UIImage) {
        DispatchQueue.main.async {
            if self.profilePic.count == 0 {
                self.profilePic.append(image)
            } else {
                self.profilePic[0] = image
            }
        }
    }
    
    // Photos picked from PhotoPicker
    func handleResults(_ results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
                guard let image = imageObject as? UIImage else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.profilePic.append(image)
                }
            }
        }
    }
    
    // Attempt to login to MyDailyLog
    func login(completion: @escaping (Bool) -> Void) {
        LoginManager.shared.login(withEmail: userEmail, withPassword: userPassword) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case.failure(let iError):
                error = iError
                completion(false)
            }
        }
    }
    
    // Attempt to send email link to reset password
    func resetPassword(completion: @escaping (Bool) -> Void) {
        LoginManager.shared.resetPassword(withEmail: userEmail) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case .failure(let iError):
                error = iError
                completion(false)
            }
        }
        userEmail = ""
    }
    
    // Attempt to sign up for an account for MyDailyLog
    func signup(withName name: String, withEmail userEmail: String, withPassword userPassword: String, withProfilePic pic: Data?, completion: @escaping (Bool) -> Void) {
        LoginManager.shared.signUp(withEmail: userEmail, withPassword: userPassword) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                // After uploading metadata to FireStore, upload profileImage to Storage, due to large size
                DatabaseManager.shared.insertUser(user: User(userName: name, userEmail: userEmail, userImage: pic!)) { (result: Result<Bool, DatabaseManager.FireStoreError>) in
                    switch result {
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
            case .failure(let iError):
                error = iError
                completion(false)
            }
        }
    }
    
}
