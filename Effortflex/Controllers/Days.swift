//
//  Days.swift
//  Effortflex
//
//  Created by Gary Naz on 5/8/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct Days : Decodable {
    var dow : String
    var workouts : [Workouts]
    
//    var dictionary: [String : Any] {
//        return ["dow" : dow]
//    }
}

//extension Days {
//    init?(dictionary: [String : Any], workouts : [Workouts]) {
//        guard let dow = dictionary["dow"] as? String else { return nil }
//
//        self.init(dow: dow, workouts: workouts)
//    }
//}
