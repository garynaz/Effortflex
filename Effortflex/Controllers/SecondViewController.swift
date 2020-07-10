
//  SecondViewController.swift
//  SectionRowsTutorial

//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.


import UIKit
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn

class SecondViewController: UITableViewController {
    
    var textField1 = UITextField()
    
    weak var buttonActionToEnable: UIAlertAction?
    
    var indexToRemove : IndexPath?
    
    var selectedWorkout : Workout?
    var exerciseArray : [Exercise] = []
    
    var workoutCollection : CollectionReference?
    var exerciseCollection : CollectionReference?
    var rootWsrCollection : CollectionReference?
    
    var authHandle : AuthStateDidChangeListenerHandle?
    var feedback : ListenerRegistration?
    var deleteFeedback : ListenerRegistration?
    
    var userIdRef = ""
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        vcBackgroundImg()
        navConAcc()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - viewWillAppear()
    override func viewWillAppear(_ awnimated: Bool) {
        
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userIdRef = user!.uid
            self.workoutCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/Workouts/")
            self.exerciseCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/Exercises/")
            self.rootWsrCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/WSR/")
            
            self.loadExercises()
        }
        
    }
    
    //MARK: - viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        feedback?.remove()
        deleteFeedback?.remove()
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    //MARK: - VC Background Image setup
    func vcBackgroundImg(){
        let backgroundImage = UIImage(named: "db2")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.5
        tableView.backgroundView = imageView
    }
    
    //MARK: - Load the Data
    func loadExercises() {

        feedback = self.exerciseCollection!.whereField("Workout", isEqualTo: selectedWorkout!.workout).order(by: "Timestamp", descending: false).addSnapshotListener({ (querySnapshot, err) in

            let group = DispatchGroup()

            guard let snapshot = querySnapshot else {return}

            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    self.exerciseArray.removeAll()

                    group.enter()
                    for document in querySnapshot!.documents {

                        let workoutData = document.data()
                        let exercise = workoutData["Exercise"] as! String

                        let newExercise = Exercise(Day: self.selectedWorkout!.day, Workout: self.selectedWorkout!.workout, Exercise: exercise, Key: document.reference)
                        self.exerciseArray.append(newExercise)
                    }
                    group.leave()
                    group.notify(queue: .main){
                        self.tableView.reloadData()
                    }
                }
                
                if (diff.type == .removed) {
                     print("Document Removed")

                     self.tableView.deleteRows(at: [self.indexToRemove!], with: .automatic)
                }
            }

            }
        )}
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        print(selectedWorkout!.workout)
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise))
        navigationItem.title = selectedWorkout?.workout
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    
    //MARK: - Add a New Exercise
    @objc func addExercise() {
        
        let alert = UIAlertController(title: "New Exercise", message: "Please name your Exercise...", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        let addAction = UIAlertAction(title: "Add Exercise", style: .default) { (UIAlertAction) in
                        
            self.exerciseCollection!.addDocument(data: [
                "Day" : self.selectedWorkout!.day,
                "Workout" : self.selectedWorkout!.workout,
                "Timestamp" : FieldValue.serverTimestamp(),
                "Exercise" : "\(self.textField1.text!)"
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Exercise added.")
                }
            }
        }
        
        alert.addTextField { (alertTextField1) in
            alertTextField1.delegate = self
            alertTextField1.placeholder = "Bench Press"
            self.textField1 = alertTextField1
            alertTextField1.inputView = nil
            
            alertTextField1.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
        }
        
        buttonActionToEnable = addAction
        addAction.isEnabled = false
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data Source
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return exerciseArray.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
    
            cell.textLabel?.text = exerciseArray[indexPath.row].exercise
            cell.accessoryType = .disclosureIndicator
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.textLabel?.textColor = UIColor(red: 0.1333, green: 0.2863, blue: 0.4, alpha: 1.0)
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
    
            return cell
        }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let destinationVC = ThirdViewController()
            destinationVC.allExercises = exerciseArray
            destinationVC.selectedExercise = exerciseArray[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true )
    
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    
        @objc func textFieldChanged(_ sender: Any) {
            let textfield = sender as! UITextField
            buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
        }
    
    //MARK: - Swipe to Delete
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            if editingStyle == .delete {
    
                indexToRemove = indexPath
                
                let exerciseRef = exerciseArray[indexPath.row].exercise
                
                //Deletes all WSR's when deleting Exercises...
                deleteFeedback = rootWsrCollection!.whereField("Exercise", isEqualTo: exerciseRef).addSnapshotListener { (querySnapshot, err) in
                    let group = DispatchGroup()

                    guard let snapshot = querySnapshot else {return}

                    group.enter()
                    for exercise in snapshot.documents{
                        self.rootWsrCollection!.document(exercise.documentID).delete()
                    }
                    group.leave()
                }
                
                //Deletes Exercises...
                let selectedExercise = exerciseArray[indexPath.row].key!
                exerciseCollection!.document(selectedExercise.documentID).delete()
                exerciseArray.remove(at: indexPath.row)
            }
        }
    
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
