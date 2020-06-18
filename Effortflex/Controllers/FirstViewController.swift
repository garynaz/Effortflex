//
//  FirstViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirstViewController: UITableViewController {
    
    
    var daysOfWeek : [String] = ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    weak var buttonActionToEnable: UIAlertAction?
    
    let cellID = "WorkoutCell"
    
    let picker = UIPickerView()
    
    var indexToRemove : IndexPath?
    
    var textField1 = UITextField()
    var textField2 = UITextField()
        
    var workoutsCollection : WorkoutsCollection = WorkoutsCollection()
    var rootWorkoutsCollection : CollectionReference!
    var rootExerciseCollection : CollectionReference!
    var rootWsrCollection : CollectionReference!
    
    var userIdRef = ""
    
    var addfeedback : ListenerRegistration?
    var deleteExerciseFeedback : ListenerRegistration?
    var deleteWsrFeedback : ListenerRegistration?

    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcBackgroundImg()
        navConAcc()
        
        picker.delegate = self
        picker.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userIdRef = user!.uid
            self.rootWorkoutsCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/Workouts")
            self.rootExerciseCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/Exercises")
            self.rootWsrCollection = Firestore.firestore().collection("/Users/\(self.userIdRef)/WSR")
            self.loadData()
        }
    }
    
    //MARK: - viewDidDisappear()
    override func viewDidDisappear(_ animated: Bool) {
        addfeedback?.remove()
        deleteExerciseFeedback?.remove()
        deleteWsrFeedback?.remove()
    }
    
    //MARK: - Load the Data
    func loadData(){
        addfeedback = self.rootWorkoutsCollection.order(by: "Timestamp", descending: false).addSnapshotListener({ (querySnapshot, err) in
            
            let group = DispatchGroup()
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    self.workoutsCollection.daysCollection.removeAll()
                    
                    group.enter()
                    for document in querySnapshot!.documents {
                        
                        var foundIt = false
                        
                        let workoutData = document.data()
                        let day = workoutData["Day"] as! String
                        let workout = workoutData["Workout"] as! String
                        
                        if self.workoutsCollection.daysCollection.isEmpty {
                            
                            let newWorkout = Workout(Day: day, Workout: workout, Ref: document.reference)
                            let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
                            self.workoutsCollection.daysCollection.append(newDay)
                            continue
                        }
                        
                        if !foundIt{
                            for dayObject in self.workoutsCollection.daysCollection{
                                for dow in dayObject.workout{
                                    if dow.day == day{
                                        let newWorkout = Workout(Day: day, Workout: workout, Ref: document.reference)
                                        dayObject.workout.append(newWorkout)
                                        foundIt = true
                                        break
                                    }
                                }
                            }
                        }
                        
                        if foundIt == false{
                            let newWorkout = Workout(Day: day, Workout: workout, Ref: document.reference)
                            let newDay = Day(Day: day, Workout: newWorkout, Ref: newWorkout.key)
                            self.workoutsCollection.daysCollection.append(newDay)
                        }
                        
                    }
                    group.leave()
                    group.notify(queue: .main){
                        self.tableView.reloadData()
                    }
                }
                
                if (diff.type == .removed) {
                    print("Document Removed")
                    
                    self.tableView.deleteRows(at: [self.indexToRemove!], with: .automatic)
                    
                    if self.workoutsCollection.daysCollection[self.indexToRemove!.section].workout.isEmpty {
                        self.workoutsCollection.daysCollection.remove(at: self.indexToRemove!.section)
                        let indexSet = IndexSet(arrayLiteral: self.indexToRemove!.section)
                        self.tableView.deleteSections(indexSet, with: .automatic)
                    }
                }
            }
            
            }
        )}
    
    //MARK: - VC Background Image setup
    func vcBackgroundImg(){
        let backgroundImage = UIImage(named: "db2")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.5
        tableView.backgroundView = imageView
    }
    
    //MARK: - Navigation Bar Setup
    func navConAcc() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
        navigationItem.rightBarButtonItem = addBarButton
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.4784, green: 0.0863, blue: 0, alpha: 1.0)]
        navigationItem.title = "My workouts"
    }
    
    //MARK: - Add a New Workout
    @objc func addWorkout() {
        
        let alert = UIAlertController(title: "New Workout", message: "Please name your workout...", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let addAction = UIAlertAction(title: "Add Workout", style: .default) { (UIAlertAction) in
            
            self.rootWorkoutsCollection.addDocument(data: [
                "Day" : self.daysOfWeek[self.picker.selectedRow(inComponent: 0)],
                "Workout" : self.textField2.text!,
                "Timestamp" : FieldValue.serverTimestamp()
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Workout added.")
                }
            }
            
        }
        
        alert.addTextField { (alertTextField1) in
            alertTextField1.delegate = self
            alertTextField1.placeholder = "Day of Week"
            alertTextField1.text = self.textField1.text
            self.textField1 = alertTextField1
            alertTextField1.inputView = self.picker
            alertTextField1.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
        }
        
        alert.addTextField { (alertTextField2) in
            alertTextField2.delegate = self
            alertTextField2.placeholder = "Muscle Group"
            self.textField2 = alertTextField2
            alertTextField2.inputView = nil
            alertTextField2.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
            
        }
        
        buttonActionToEnable = addAction
        addAction.isEnabled = false
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func textFieldChanged(_ sender: Any) {
        let textfield = sender as! UITextField
        buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
    }
    
    
    //MARK: - TableView DataSource and Delegate Methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.text = workoutsCollection.daysCollection[section].day
        label.backgroundColor = UIColor.lightText
        label.textColor = UIColor(red: 0, green: 0.451, blue: 0.8471, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.adjusted
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return workoutsCollection.daysCollection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsCollection.daysCollection[section].workout.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = workoutsCollection.daysCollection[indexPath.section].workout[indexPath.row].workout
        cell.textLabel?.textAlignment = .center
        cell.accessoryType = .disclosureIndicator
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.textLabel?.textColor = UIColor(red: 0.1333, green: 0.2863, blue: 0.4, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = SecondViewController()
        destinationVC.selectedWorkout = workoutsCollection.daysCollection[indexPath.section].workout[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //MARK: - Swipe To Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            indexToRemove = indexPath
            
            //Deletes all Exercises when deleting workouts...
            let workoutRef = workoutsCollection.daysCollection[indexPath.section].workout[indexPath.row].workout
            
            deleteWsrFeedback = rootWsrCollection.whereField("Workout", isEqualTo: workoutRef).addSnapshotListener { (querySnapshot, err) in
                let group = DispatchGroup()

                guard let snapshot = querySnapshot else {return}

                group.enter()
                for wsr in snapshot.documents{
                    self.rootWsrCollection.document(wsr.documentID).delete()
                }
                group.leave()
            }
            
            deleteExerciseFeedback = rootExerciseCollection.whereField("Workout", isEqualTo: workoutRef).addSnapshotListener { (querySnapshot, err) in
                let group = DispatchGroup()
                
                guard let snapshot = querySnapshot else {return}
                
                group.enter()
                for exercise in snapshot.documents{
                    self.rootExerciseCollection.document(exercise.documentID).delete()
                }
                group.leave()
            }

            
            let selectedKey = workoutsCollection.daysCollection[indexPath.section].workout[indexPath.row].key!
            rootWorkoutsCollection.document(selectedKey.documentID).delete()
            workoutsCollection.daysCollection[indexPath.section].workout.remove(at: indexPath.row)
        }
    }
    
}


//MARK: - PickerView Delegate Methods
extension FirstViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField1.text = daysOfWeek[row]
    }
    
}

//MARK: - Textfield Delegate Methods
extension FirstViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharsSet = CharacterSet(charactersIn: string)
        if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 20 {
            return true
        }
        return false
    }
}
