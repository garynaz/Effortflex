//
//  ViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/8/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//



import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var days : Results<Days>?
    var workouts : Results<Workouts>?
    
    var daysOfWeek : [String] = ["Monday", "Tuesday", "Wednsday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var indexCheck : Int = 0
    
    let picker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.dataSource = self
        
        navigationItem.title = "Workouts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
        self.navigationItem.rightBarButtonItem = addBarButton
        
        loadDays()
        
    }
    
    @objc func addWorkout() {
        var textField = UITextField()
        var containsDay = false
        var counter = 0
        let alert = UIAlertController(title: "New Workout", message: "Please name your workout...", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Workout", style: .default) { (UIAlertAction) in
            //Add day and workout to database
            //if day exists, append workout to the existing day.
            //if day doesn't exist, create a day and append workout to newly created day object.
            
            //First, we have to create an initial days object...
            //Need to check if ANY of the weekdays == picked day, only execute then.
            
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
                    newWorkout.title = textField.text!
                    
                    try! self.realm.write {
                        self.days?[counter].workout.append(newWorkout)
                        self.loadDays()
                    }
                } else {
                    let dow = Days()
                    let newWorkout = Workouts()
                    dow.weekday = self.daysOfWeek[self.picker.selectedRow(inComponent: 0)]
                    newWorkout.title = textField.text!
                    dow.workout.append(newWorkout)
                    self.save(newDay: dow)
                }
            } else {
                let dow = Days()
                let newWorkout = Workouts()
                dow.weekday = self.daysOfWeek[self.picker.selectedRow(inComponent: 0)]
                newWorkout.title = textField.text!
                dow.workout.append(newWorkout)
                
                self.save(newDay: dow)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Muscle Group"
            textField = alertTextField
            alertTextField.inputView = self.picker
        }
        
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = days?[section].weekday ?? "Section Header"
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days?[section].workout.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let workout = days?[indexPath.section].workout[indexPath.row].title ?? "Workout"
                
        cell.textLabel?.text = "\(workout)  Section:\(indexPath.section) Row:\(indexPath.row)"
        
        return cell
    }
    
    
    
    func loadDays() {
        days = realm.objects(Days.self)
        tableView.reloadData()
    }
    
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



extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfWeek[row]
    }
}


