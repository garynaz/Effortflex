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
    
    @objc dynamic var weight = 0
    @objc dynamic var sets = 0
    @objc dynamic var reps = 0
    @objc dynamic var counter = 0
    var parentExercise = LinkingObjects(fromType: Exercises.self, property: "wsr")

}
