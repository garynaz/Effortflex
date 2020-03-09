//
//  WeightSetsReps.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 1/4/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import RealmSwift


class WeightSetsReps : Object {
    
    @objc dynamic var weight : Double = 0
    @objc dynamic var reps : Double = 0
    @objc dynamic var notes : String = ""
    var parentExercise = LinkingObjects(fromType: Exercises.self, property: "wsr")
}
