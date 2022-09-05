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
    
    
	func createDayWorkout(day: String, workout: String, idRef: String){
        
        //If day doesn't exist, create new Day, otherwise add to existing day object...

        if daysCollection.isEmpty {
			let newWorkout = Workout(Day: day, Workout: workout, IdRef: idRef)
            let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
            daysCollection.append(newDay)
        } else {
            for dayObject in daysCollection{
                for dow in dayObject.workout{
                    if dow.day == day{
						let newWorkout = Workout(Day: day, Workout: workout, IdRef: idRef)
                        dayObject.workout.append(newWorkout)
                    }else{
						let newWorkout = Workout(Day: day, Workout: workout, IdRef: idRef)
                        let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
                        daysCollection.append(newDay)
                    }
                }
            }
        }
        
    }
    
}
