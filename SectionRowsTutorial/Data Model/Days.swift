//
//  Days.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/12/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import Foundation
import RealmSwift

class Days : Object {
    
    @objc dynamic var weekday : String = ""
    let workout = List<Workouts>()
    
}
