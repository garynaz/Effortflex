//
//  Day.swift
//  Effortflex
//
//  Created by Gary Naz on 6/7/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift


class Day : NSObject{
    
    var day:String
    var key:DocumentReference!
    var workout:[Workout] = []
    
    init(Day: String, Workout: Workout, Ref:DocumentReference) {
        self.day = Day
        self.key = Ref
        self.workout.append(Workout)
    }
    
}
