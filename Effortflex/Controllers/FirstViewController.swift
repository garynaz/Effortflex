//
//  FirstViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/29/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var days : Results<Days>?
    var workouts : Results<Workouts>?
    
    var daysOfWeek : [String] = ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    weak var buttonActionToEnable: UIAlertAction?
    
    var indexCheck : Int = 0
    let cellID = "WorkoutCell"
    
    let picker = UIPickerView()
    
    var textField1 = UITextField()
    var textField2 = UITextField()
    
    
    
//MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()

        navConAcc()
        loadDays()
    }
    
//MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
//        let backgroundImage = UIImage(named: "weights")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFit
//
//        tableView.backgroundView = imageView
    }
    
    
//MARK: - Navigation Bar Setup
    func navConAcc() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
        navigationItem.rightBarButtonItem = addBarButton
        
        navigationItem.title = "My workouts"
    }
    
    
//MARK: - Add a New Workout
    @objc func addWorkout() {
        
        var containsDay = false
        var counter = 0
        
        let alert = UIAlertController(title: "New Workout", message: "Please name your workout...", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        let addAction = UIAlertAction(title: "Add Workout", style: .default) { (UIAlertAction) in

            if self.days?.isEmpty == false {
                for i in 0...(self.days!.count - 1) {
                    
                    if self.days?[i].weekday == self.daysOfWeek[self.picker.selectedRow(inComponent: 0)] {
                        containsDay = true
                        counter = i
                        break
                    }
                }
                
                if containsDay == true {
                    let newWorkout = Workouts()
                    newWorkout.title = self.textField2.text!
                    
                    try! self.realm.write {
                        self.days?[counter].workout.append(newWorkout)
                        self.loadDays()
                    }
                } else {
                    let dow = Days()
                    let newWorkout = Workouts()
                    dow.weekday = self.daysOfWeek[self.picker.selectedRow(inComponent: 0)]
                    newWorkout.title = self.textField2.text!
                    dow.workout.append(newWorkout)
                    self.save(newDay: dow)
                }
            } else {
                let dow = Days()
                let newWorkout = Workouts()
                dow.weekday = self.daysOfWeek[self.picker.selectedRow(inComponent: 0)]
                newWorkout.title = self.textField2.text!
                dow.workout.append(newWorkout)
                
                self.save(newDay: dow)
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
        
        self.buttonActionToEnable = addAction
        addAction.isEnabled = false
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldChanged(_ sender: Any) {
        let textfield = sender as! UITextField
        self.buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
    }
    
    
//MARK: - TableView DataSource and Delegate Methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = days?[section].weekday ?? "Section Header"
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.adjusted
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days?[section].workout.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let workout = days?[indexPath.section].workout[indexPath.row].title ?? "Workout"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "\(workout)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = SecondViewController()
        destinationVC.selectedWorkout = days?[indexPath.section].workout[indexPath.row]
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
//MARK: - Swipe To Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            try! realm.write {
                
                if days?[indexPath.section].workout[indexPath.row].exercise.isEmpty == false {
                    
                    if let selectedWorkout = days?[indexPath.section].workout[indexPath.row] {
                        let thisWorkoutsExercises = realm.objects(Exercises.self).filter("ANY parentWorkout == %@", selectedWorkout)
                        // Filter function to get all wsr's associated with the selected workout...
                        let thisWorkoutsWsr = realm.objects(WeightSetsReps.self).filter("ANY parentExercise IN %@", thisWorkoutsExercises)
                        
                        realm.delete(thisWorkoutsWsr)
                        realm.delete(thisWorkoutsExercises)
                        realm.delete((days?[indexPath.section].workout[indexPath.row])!)
                    }
                } else {
                    realm.delete((days?[indexPath.section].workout[indexPath.row])!)
                }
                
                
                tableView.beginUpdates()
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                if days?[indexPath.section].workout.isEmpty == true {
                    realm.delete((days?[indexPath.section])!)
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .automatic)
                }
                
                tableView.endUpdates()
            }
        }
    }
    
    
//MARK: - Load Data
    func loadDays() {
        days = realm.objects(Days.self)
        tableView.reloadData()
    }
    
//MARK: - Save Data
    func save(newDay : Days) {
        do {
            try realm.write {
                realm.add(newDay)
            }
        } catch {
            print("Error saving day \(error)")
        }
        self.loadDays()
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
