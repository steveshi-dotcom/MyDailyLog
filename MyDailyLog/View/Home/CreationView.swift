//
//  CreationPage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI

struct CreationView: View {
    @StateObject private var creationVM = CreationModel()
    @State private var showingCameraPicker: Bool = false
    @State private var logImage: Image = Image("mcgill-library-JcoZbI7Ve1Q-unsplash")
    @State private var logImageCap: String = "Image Caption"
    @State private var logText: String = "Log Body"
    @State private var showInsufAlert: Bool = false
    @State private var ShowCheckMark: Bool = false  //TODO: NEED TO WORK ON A CHECK MARK VIEW
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(175), spacing: 5), count: 2)) {
                        ZStack {
                            if creationVM.images.count != 0 {
                                Image(uiImage: creationVM.images[0])
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                logImage
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .onTapGesture {
                            showingCameraPicker.toggle()
                        }
                        TextEditor(text: $logImageCap)
                            .background(.blue)
                    }
                TextEditor(text: $logText)
                    .background(.blue)
            }
            .navigationTitle("New Log")
            .navigationBarItems(
                trailing:
                    Button("Save") {
                        guard creationVM.images.count != 0 else {
                            showInsufAlert.toggle()
                            return
                        }
                        let logId = UUID().uuidString
                        //let logTimestamp = Calendar.current.dateComponents([.month, .day, .year], from: Date())
                        let dailyLog = Log(id: logId, timeStamp: Date().timeIntervalSince1970, headerImageUrl: (creationVM.images[0].jpegData(compressionQuality: 0.8))!, headerImageCap: logImageCap, bodyText: logText)
                        creationVM.saveLog(withLog: dailyLog) { result in
                            if result {
                                creationVM.images = []
                                logText = ""
                                logImageCap = ""
                                ShowCheckMark = true
                            }
                        }
                    }
            )
            .alert(isPresented: $showInsufAlert) {
                Alert(title: Text("Insufficient Info"), message: Text("Plz ensure all fields represent thoughful information that you can look back at in the future"))
            }
        }
        .sheet(isPresented: $showingCameraPicker) {
            CreationCameraPickerView(isPresented: $showingCameraPicker) {
                creationVM.handleAddedImage($0)
            }
        }
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
