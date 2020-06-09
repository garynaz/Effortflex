
//  SecondViewController.swift
//  SectionRowsTutorial

//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.


import UIKit
import Firebase
import FirebaseFirestoreSwift

class SecondViewController: UITableViewController {
    
//    var rootDocument : DocumentReference!
//    var textField1 = UITextField()
//
//    weak var buttonActionToEnable: UIAlertAction?
//
//    var exercises = [Exercises]()
//    var exerciseCounter = 0
//
    var selectedWorkout : Day?
    
    
    //MARK: - viewDidLoad()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let currentUser = Auth.auth().currentUser
//        rootDocument = Firestore.firestore().document("/users/\(currentUser!.uid)/Days/\(selectedWorkout!.dayId)/Workouts/\(selectedWorkout!.workout)")
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
//        tableView.tableFooterView = UIView()
//        navConAcc()
//
//        loadExercises { (Bool) in
//            if Bool == true {
//                self.exerciseCounter = self.exercises.count
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    //MARK: - viewWillAppear()
//    override func viewWillAppear(_ animated: Bool) {
//        let backgroundImage = UIImage(named: "db2")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFill
//        imageView.alpha = 0.5
//
//        tableView.backgroundView = imageView
//    }
    
    //MARK: - Load Data
//    func loadExercises(completion: @escaping (Bool) -> ()) {
//
//        let group = DispatchGroup()
//
//        self.rootDocument.collection("Exercises").getDocuments { (snapshot, err) in
//
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                guard let exerciseDocs = snapshot?.documents else { return }
//
//                self.exercises.removeAll()
//
//                try! exerciseDocs.forEach ({exercise in
//                    group.enter()
//
//                    let exerciseDoc : Exercises = try exercise.decoded()
//                    let exerciseString = exerciseDoc.exercise
//
//                    let newExercises = Exercises(exercise: exerciseString)
//                    self.exercises.append(newExercises)
//
//                    group.leave()
//                })
//            }
//
//            group.notify(queue: .main) {
//                completion(true)
//            }
//
//        }
//    }
    
    //MARK: - Navigation Bar Setup
//    func navConAcc(){
//        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise))
//        navigationItem.title = selectedWorkout?.workout
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = addBarButton
//    }
    
    
    //MARK: - Add a New Exercise
//    @objc func addExercise() {
//
//        let alert = UIAlertController(title: "New Exercise", message: "Please name your Exercise...", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
//            alert.dismiss(animated: true, completion: nil)
//        }
//        let addAction = UIAlertAction(title: "Add Exercise", style: .default) { (UIAlertAction) in
//
//            self.rootDocument.collection("Exercises").document("\(self.textField1.text!)").setData(["exercise" : "\(self.textField1.text!)"])
//
//            self.loadExercises { (Bool) in
//                if Bool == true {
//                    self.exerciseCounter = self.exercises.count
//                    self.tableView.reloadData()
//                }
//            }
//        }
//
//        alert.addTextField { (alertTextField1) in
//            alertTextField1.delegate = self
//            alertTextField1.placeholder = "Bench Press"
//            self.textField1 = alertTextField1
//            alertTextField1.inputView = nil
//
//            alertTextField1.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
//        }
//
//        self.buttonActionToEnable = addAction
//        addAction.isEnabled = false
//
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//    }
    
    // MARK: - TableView Data Source
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return exerciseCounter
//    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
//
//        cell.textLabel?.text = exercises[indexPath.row].exercise
//        cell.accessoryType = .disclosureIndicator
//        cell.layer.backgroundColor = UIColor.clear.cgColor
//        cell.textLabel?.textColor = UIColor(red: 0.1333, green: 0.2863, blue: 0.4, alpha: 1.0)
//        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
//
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let destinationVC = ThirdViewController()
//        //            destinationVC.selectedExercise = exercises![indexPath.row]
//        //            destinationVC.allExercises = exercises
//
//        tableView.deselectRow(at: indexPath, animated: true )
//
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
    
//    @objc func textFieldChanged(_ sender: Any) {
//        let textfield = sender as! UITextField
//        self.buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
//    }
    
    //MARK: - Swipe to Delete
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            let selectedExercise = exercises[indexPath.row].exercise
//
//            self.rootDocument.collection("Exercises").document(selectedExercise).delete()
//
//            self.loadExercises { (Bool) in
//                if Bool == true {
//                    self.exerciseCounter = self.exercises.count
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                    tableView.reloadData()
//                }
//            }
//
//        }
//    }
    
}

//MARK: - Textfield Delegate Methods
extension SecondViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharsSet = CharacterSet(charactersIn: string)
        if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 21 {
            return true
        }
        return false
    }
}
