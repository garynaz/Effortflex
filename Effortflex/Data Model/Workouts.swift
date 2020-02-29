//
//  Workouts.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/12/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import Foundation
import RealmSwift

class Workouts : Object {
    
    @objc dynamic var title : String = ""
    var parentDay = LinkingObjects(fromType: Days.self, property: "workout")
    
    let exercise = List<Exercises>()
}
