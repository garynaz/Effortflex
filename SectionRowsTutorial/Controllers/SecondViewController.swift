//
//  SecondViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UITableViewController {

    let realm = try! Realm()
    
    var exercises : Results<Exercises>?
    
    var selectedWorkout : Workouts? {
        didSet{
            loadExercises()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Exercises"
        navigationController?.navigationBar.prefersLargeTitles = true

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWorkout?.exercise.count ?? 0
    }

    
    func loadExercises() {
        exercises = selectedWorkout?.exercise.sorted(byKeyPath: "exerciseName", ascending: true)
        tableView.reloadData()
    }
   

}
