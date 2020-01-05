//
//  Exercises.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import Foundation
import RealmSwift

class Exercises : Object {
    
    @objc dynamic var exerciseName : String = ""
    
    var parentWorkout = LinkingObjects(fromType: Workouts.self, property: "exercise")
    
    let wsr = List<WeightSetsReps>()
}
