//
//  HomeModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/18/22.
//

import Foundation
import Firebase

class HomeModel: ObservableObject {
    
    var myName: String {
        var currEmail = Auth.auth().currentUser?.email
        
        return "asfd"
    }
}
