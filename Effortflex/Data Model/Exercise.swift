//
//  Exercise.swift
//  Effortflex
//
//  Created by Gary Naz on 6/14/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class Exercise : NSObject{
    
    var day : String
    var workout : String
    var exercise : String
	var uid: String
    var key : DocumentReference!
    
	init(Day: String, Workout: String, Exercise: String, Key: DocumentReference, IdRef: String) {
        self.day = Day
        self.workout = Workout
        self.exercise = Exercise
        self.key = Key
		self.uid = IdRef
    }
    
}
