//
//  CreationPage.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Inject

// Creation Tab where user can take a picture, add caption, and write a short summary of the specific event, etc
struct CreationView: View {
    @ObserveInjection var io
    @StateObject private var creationVM = CreationModel()
    @FocusState private var userInputFocus: Bool

    @State private var showingCameraPicker: Bool = false
    @State private var logImage: Image = Image("skyler-ewing-Djneft6JzNM-unsplash")
    @State private var logImageCap: String = "Image Caption"
    @State private var logText: String = "Log Body"
    @State private var showInsufAlert: Bool = false
    @State private var ShowCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            // Two row view with the top row as two column for an picture(left) + pictureCaption(right)
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(190), spacing: 8), count: 2)) {
                        ZStack(alignment: .center) {
                            // Show a puppy placeholder unless a user takes a picture, no photopicker allowed.
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
                            // Text editor area where user input their short caption, limit at 100 chars
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
                    // Text editor area where user input their summary, could be thoughts, events
                    // anything random they find interesting to keep track of and look in the future
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
                // A post btn on the top right handcorner that will allow the user to post the log to FireBase
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
                // Present alert that not allow input has been filed
                Alert(title: Text("Insufficient Info"), message: Text("Please ensure all fields represent thoughful information that you can look back at in the future"))
            }
        }
        .sheet(isPresented: $showingCameraPicker) {
            // Pop up camera picker view that user can use to take a picture for the log
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
