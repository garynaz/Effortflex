//
//  Workout.swift
//  Effortflex
//
//  Created by Gary Naz on 6/5/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class Workout: NSObject{
    var day : String
    var workout : String
	var uid: String
    var key : DocumentReference!

    
    init(Day: String, Workout: String, IdRef: String) {
        let ref : DocumentReference!
        let db : Firestore!
        db = Firestore.firestore()
        ref = db.collection("Users").document("\(Auth.auth().currentUser!.uid)").collection("Workouts").addDocument(data: [
            "Day" : Day,
            "Workout" : Workout,
			"uid" : IdRef
        ]){ err in
           if let err = err {
              print("Error adding document: \(err)")
           } else {
            print("Document added.")
           }
        }

        self.day = Day
        self.workout = Workout
        self.key = ref
		self.uid = IdRef
    }

	init(Day: String, Workout: String, Ref: DocumentReference, IdRef: String) {
        self.day = Day
        self.workout = Workout
        self.key = Ref
		self.uid = IdRef
    }
    
    
}
