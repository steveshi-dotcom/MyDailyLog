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
    @State private var logImageCap: String = "Image Cap"
    @State private var logText: String = "Log Body"
    @State private var showInsufAlert: Bool = false
    @State private var ShowCheckMark: Bool = false  //TODO: NEED TO WORK ON A CHECK MARK VIEW
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(190), spacing: 10), count: 2)) {
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
                        .border(.gray, width: 5)
                        .onTapGesture {
                            showingCameraPicker.toggle()
                        }
                        ZStack {
                            TextEditor(text: $logImageCap)
                                .multilineTextAlignment(.center)
                                .frame(width: 175, height: 150)
                                .border((logImageCap.count > 99 ? .red : .black), width: 5)
                                .cornerRadius(12)
                                .padding(.trailing, 12)
                        }
                    }
                    .background(.blue)
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.gray]), startPoint: .leading, endPoint: .trailing)
                    TextEditor(text: $logText)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2 - 20)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .border(.gray, width: 10)
                .background(.indigo)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .navigationTitle("New Log")
            .navigationBarItems(
                trailing:
                    Button("Post") {
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
