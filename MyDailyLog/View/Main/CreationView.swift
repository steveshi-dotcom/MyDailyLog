//
//  CreationPage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Inject

struct CreationView: View {
    @ObserveInjection var io
    @StateObject private var creationVM = CreationModel()
    @State private var showingCameraPicker: Bool = false
    @State private var logImage: Image = Image("skyler-ewing-Djneft6JzNM-unsplash")
    @State private var logImageCap: String = "Image Caption"
    @State private var logText: String = "Log Body"
    @State private var showInsufAlert: Bool = false
    @State private var ShowCheckMark: Bool = false
    @FocusState private var userInputFocus: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(190), spacing: 8), count: 2)) {
                        ZStack(alignment: .center) {
                            if creationVM.images.count != 0 {
                                Image(uiImage: creationVM.images[0])
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                logImage
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .onTapGesture {
                            showingCameraPicker.toggle()
                        }
                        ZStack {
                            TextEditor(text: $logImageCap)
                                .cornerRadius(12)
                                .multilineTextAlignment(.center)
                                .frame(width: 175, height: 150)
                                .padding(.trailing, 10)
                                .focused($userInputFocus)
                        }
                    }
                    .background(Color(UIColor.systemCyan))
                    .cornerRadius(12.5)
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.cyan]), startPoint: .leading, endPoint: .trailing)
                    TextEditor(text: $logText)
                        .cornerRadius(12.5)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2 - 20)
                        .focused($userInputFocus)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .border(Color(UIColor.systemCyan), width: 10)
                .cornerRadius(12.5)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .navigationTitle("New Log")
            .navigationBarItems(
                trailing:
                    Button("Post") {
                        userInputFocus.toggle()
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
        .enableInjection()
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
