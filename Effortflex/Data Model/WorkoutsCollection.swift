//
//  WorkoutsCollection.swift
//  Effortflex
//
//  Created by Gary Naz on 6/5/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class WorkoutsCollection {
    
    var workoutsCollection = [Workout]()
    
    
    func createWorkout(day: String, workout: String){
        let newWorkout = Workout(Day: day, Workout: workout)
        
        workoutsCollection.append(newWorkout)
    }
    
    func removeWorkout(Workout: Workout){
        
        let db : Firestore!
        db = Firestore.firestore()
        db.collection("\(Auth.auth().currentUser!.uid)").document(Workout.key.documentID).delete()
        
        if let index = workoutsCollection.firstIndex(of: Workout){
            workoutsCollection.remove(at: index)
        }
    }
    
}
