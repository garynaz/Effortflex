//
//  Workouts.swift
//  
//
//  Created by Gary Naz on 5/8/20.
//

import Foundation
import FirebaseFirestoreSwift


struct Workouts : Decodable {
    var dayId : String
    var workout : String
    var exercises : [Exercises]?
}



