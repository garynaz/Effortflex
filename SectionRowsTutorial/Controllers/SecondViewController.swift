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
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
        navConAcc()
    }
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise))
        navigationItem.title = selectedWorkout?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addBarButton
    }

    // MARK: - TableView Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise = selectedWorkout?.exercise[indexPath.row]
        
        cell.textLabel?.text = "\(exercise!.exerciseName)  Section:\(indexPath.section) Row:\(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = ThirdViewController()
        destinationVC.selectedExercise = exercises![indexPath.row]
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //MARK: - Add a New Exercise
    
    @objc func addExercise() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Exercise", message: "Please name your Exercise...", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Exercise", style: .default) { (UIAlertAction) in
            //Add Exercise to database.
            //Append exercise to selected workout object.
            let exercise = Exercises()
            exercise.exerciseName = textField.text!
            try! self.realm.write {
                self.selectedWorkout?.exercise.append(exercise)
                self.loadExercises()
            }
        }
        
        alert.addTextField { (alertTextField1) in
            alertTextField1.placeholder = "Bench Press"
            alertTextField1.text = textField.text
            textField = alertTextField1
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Swipe to Delete
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            try! realm.write {
                realm.delete((selectedWorkout?.exercise[indexPath.row])!)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    
    //MARK: - Load Data
    func loadExercises() {
        exercises = selectedWorkout?.exercise.sorted(byKeyPath: "exerciseName", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Save Data
    func save(newExercise : Exercises) {
        do {
            try realm.write {
                realm.add(newExercise)
            }
        } catch {
            print("Error saving Exercise \(error)")
        }
        self.loadExercises()
    }
   

}
