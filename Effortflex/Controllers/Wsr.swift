//
//  Wsr.swift
//  Effortflex
//
//  Created by Gary Naz on 6/16/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class Wsr : NSObject{
    
    var day : String
    var workout : String
    var exercise : String
    var weight : Double
    var reps : Double
    var notes : String
    var key : DocumentReference!

    
    init(Day: String, Workout: String, Exercise: String, Weight: Double, Reps: Double, Notes: String, Key: DocumentReference) {
        self.day = Day
        self.workout = Workout
        self.exercise = Exercise
        self.weight = Weight
        self.reps = Reps
        self.notes = Notes
        self.key = Key
    }
}
