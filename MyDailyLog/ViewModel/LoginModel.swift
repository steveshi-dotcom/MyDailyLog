//
//  LoginModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import Foundation
import PhotosUI

class LoginModel: ObservableObject {
    @Published var error: Authentification.AuthentificationError?
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var profilePic: [UIImage] = []
    
    var canTakePictures: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    func handleAddedImage(_ image: UIImage) {
        DispatchQueue.main.async {
            if self.profilePic.count == 0 {
                self.profilePic.append(image)
            } else {
                self.profilePic[0] = image
            }
        }
    }
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
    
    func signup(withName name: String, withEmail userEmail: String, withPassword userPassword: String, withProfilePic pic: Data?, completion: @escaping (Bool) -> Void) {
        LoginManager.shared.signUp(withEmail: userEmail, withPassword: userPassword) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
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
