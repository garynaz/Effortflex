//
//  WorkoutsCollection.swift
//  Effortflex
//
//  Created by Gary Naz on 6/5/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class WorkoutsCollection {
    
    var daysCollection = [Day]()
    
    
    func createDayWorkout(day: String, workout: String){
        
        //If day doesn't exist, create new Day, otherwise add to existing day object...

        if daysCollection.isEmpty {
            let newWorkout = Workout(Day: day, Workout: workout)
            let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
            daysCollection.append(newDay)
        } else {
            for dayObject in daysCollection{
                for dow in dayObject.workout{
                    if dow.day == day{
                        let newWorkout = Workout(Day: day, Workout: workout)
                        dayObject.workout.append(newWorkout)
                    }else{
                        let newWorkout = Workout(Day: day, Workout: workout)
                        let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
                        daysCollection.append(newDay)
                    }
                }
            }
        }
        
    }
    
    
    func removeWorkout(Workout: Day){
        
        let db : Firestore!
        db = Firestore.firestore()
        db.collection("Users").document("\(Auth.auth().currentUser!.uid)").collection("Workouts").document(Workout.key.documentID).delete()
        
        if let index = daysCollection.firstIndex(of: Workout){
            daysCollection.remove(at: index)
        }
    }
    
}
