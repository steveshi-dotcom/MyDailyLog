//
//  CreationModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/17/22.
//

import Firebase
import PhotosUI

class CreationModel: ObservableObject {
    @Published var CreationModel = [Log]()
    @Published var images: [UIImage] = []
    
    var canTakePictures: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func handleAddedImage(_ image: UIImage) {
        DispatchQueue.main.async {
            if self.images.count == 0 {
                self.images.append(image)
            } else {
                self.images[0] = image
            }
        }
    }
    
    func handleResults(_ results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
                guard let image = imageObject as? UIImage else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.images.append(image)
                }
            }
        }
    }
    
    func saveLog(completion: @escaping (Bool) -> Void) {
        
    }
}
