//
//  PhotoPickerView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import SwiftUI
import PhotosUI

struct CreationPhotoPickerView: UIViewControllerRepresentable {
    func makeCoordinator() -> PhotoPickerViewCoordinator {
        PhotoPickerViewCoordinator()
    }
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 2
        configuration.selection = .ordered
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
        
}


final class PhotoPickerViewCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("fon")
    }
}
