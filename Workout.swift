//
//  Workout.swift
//  Effortflex
//
//  Created by Gary Naz on 6/5/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Workout : Equatable{
    var day : String
    var workout : String
    var key : DocumentReference!
    
    
    init(Day: String, Workout: String) {
        let ref : DocumentReference!
        let db : Firestore!
        db = Firestore.firestore()

        ref = db.collection("\(Auth.auth().currentUser!.uid)").addDocument(data: [
            "Day" : Day,
            "Workout" : Workout
        ])

        self.day = Day
        self.workout = Workout
        self.key = ref
    }

    init(Day: String, Workout: String, Ref: DocumentReference) {
        self.day = Day
        self.workout = Workout
        self.key = Ref
    }
    
    
}
