//
//  CreationPage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct CreationView: View {
    @StateObject private var creationVM = CreationModel()
    @State private var showingImagePicker: Bool = false
    @State private var showingCameraPicker: Bool = false
    @State private var logImage: UIImage?
    @State private var logText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(175), spacing: 10), count: 2)) {
                        ForEach(creationVM.images.indices, id: \.self) {
                            Image(uiImage: creationVM.images[$0])
                                .resizable()
                                .scaledToFill()
                        }
                    }
                
            }
            .navigationTitle("Hello")
            .navigationBarItems(
                trailing:
                    ImagesBtn
            )
        }
        .sheet(isPresented: $showingCameraPicker) {
            CreationCameraPickerView(isPresented: $showingCameraPicker) {
                creationVM.handleAddedImage($0)
            }
        }
    }
    private var ImagesBtn: some View {
        HStack {
            if creationVM.canTakePictures {
                Button(action: { showingCameraPicker.toggle() }) {
                    Image(systemName: "camera")
                }
            }
        }
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
