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
    @State private var logImage: UIImage?
    @State private var logText: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.fixed(175), spacing:10),
                                    GridItem(.fixed(175), spacing:10)]) {
                    Image("sam")
                        .resizable()
                        .scaledToFit()
                    Image("sam")
                        .resizable()
                        .scaledToFit()
                }
                
            }
            .navigationTitle("Hello")
            .navigationBarItems(
                trailing:
                    Button(action: { showingImagePicker.toggle()}) {
                        Image(systemName: "plus.circle")
                    }
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            CreationPhotoPickerView()
        }
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
