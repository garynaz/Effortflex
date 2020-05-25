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
    
    var textField1 = UITextField()
    var textField2 = UITextField()
    
    var rootCollection : CollectionReference!
    var userIdRef = ""
    var dayCounter = 0
    var dataArray = [Days]()
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcBackgroundImg()
        navConAcc()
        
        picker.delegate = self
        picker.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userIdRef = user!.uid
            self.rootCollection = Firestore.firestore().collection("/users/\(self.userIdRef)/Days")
            
            self.loadData { (Bool) in
                if Bool == true {
                    self.dayCounter = self.dataArray.count
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    //MARK: - Load Data
    func loadData(completion: @escaping (Bool) -> ()){
        
        let group = DispatchGroup()
        
        self.rootCollection.getDocuments (completion: { (snapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err.localizedDescription)");
            }
            else {
                
                guard let dayDocument = snapshot?.documents else { return }
                
                self.dataArray.removeAll()
                
                for day in dayDocument {
                    
                    group.enter()
                    
                    self.rootCollection.document(day.documentID).collection("Workouts").getDocuments {(snapshot, err) in
                        
                        var workouts = [Workouts]()
                        
                        let workoutDocument = snapshot!.documents
                        
                        try! workoutDocument.forEach({doc in
                            
                            let workoutDoc: Workouts = try doc.decoded()
                            let workoutString = workoutDoc.workout

                            let newWorkout = Workouts(dayId: workoutDoc.dayId, workout: workoutString)
                            workouts.append(newWorkout)
                        })
                        
                        let dayTitle = day.data()["dow"] as! String
                        
                        let newDay = Days(dow: dayTitle, workouts: workouts)
                        
                        self.dataArray.append(newDay)
                        
                        group.leave()
                    }
                }
                
            }
            group.notify(queue: .main){
                completion(true)
            }
        })
    }
    
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
            
            if self.dayCounter != 0 {
                
                self.rootCollection.getDocuments { (querySnapshot, err) in
                    
                    if let err = err
                    {
                        print("Error getting documents: \(err)");
                    }
                    else
                    {
                        var foundIt = false
                        
                        for document in querySnapshot!.documents {
                            if !foundIt {
                                //Pull the existing day and store the new workout within that day.
                                let myData = document.data()
                                let myDay = myData["dow"] as? String ?? ""
                                
                                if myDay == self.daysOfWeek[self.picker.selectedRow(inComponent: 0)] {
                                    
                                    self.rootCollection.document("\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])").collection("Workouts").document("\(self.textField2.text!)").setData(["workout" : "\(self.textField2.text!)", "dayId" : "\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])"])
                                    
                                    self.loadData { (Bool) in
                                        if Bool == true {
                                            self.dayCounter = self.dataArray.count
                                            self.tableView.reloadData()
                                        }
                                    }
                                    
                                    foundIt = true
                                    
                                    break
                                }
                            }
                        }
                        
                        if foundIt == false {
                            //Create new day as well as a new workout, and store the workout within the day.
                            
                            self.rootCollection.document("\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])").setData(["dow" : "\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])"])
                            
                            self.rootCollection.document("\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])").collection("Workouts").document("\(self.textField2.text!)").setData(["workout" : "\(self.textField2.text!)", "dayId" : "\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])"])
                            
                            self.loadData { (Bool) in
                                if Bool == true {
                                    self.dayCounter = self.dataArray.count
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
                
            } else {
                //If there are no days/workouts, we create new day as well as a new workout, and store the workout within the day.
                
                self.rootCollection.document("\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])").setData(["dow" : "\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])"])
                
                self.rootCollection.document("\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])").collection("Workouts").document("\(self.textField2.text!)").setData(["workout" : "\(self.textField2.text!)", "dayId" : "\(self.daysOfWeek[self.picker.selectedRow(inComponent: 0)])"])
                
                self.loadData { (Bool) in
                    if Bool == true {
                        self.dayCounter = self.dataArray.count
                        self.tableView.reloadData()
                    }
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
        self.buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
    }
    
    
    //MARK: - TableView DataSource and Delegate Methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        //Go through all the days and pull the dow. Populate the text label with the dow.
        //Get all the days, place the results inside of an array.
        
        label.text = dataArray[section].dow
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
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the count how many workouts exist for each date.
        
        return dataArray[section].workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.section].workouts[indexPath.row].workout
        cell.textLabel?.textAlignment = .center
        cell.accessoryType = .disclosureIndicator
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.textLabel?.textColor = UIColor(red: 0.1333, green: 0.2863, blue: 0.4, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = SecondViewController()
        destinationVC.selectedWorkout = dataArray[indexPath.section].workouts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //MARK: - Swipe To Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let selectedDay = dataArray[indexPath.section].dow
            let selectedWorkout = dataArray[indexPath.section].workouts[indexPath.row].workout
            
            
            self.rootCollection.document(selectedDay).collection("Workouts").document(selectedWorkout).delete()
            
            self.loadData { (Bool) in
                if Bool == true {
                    if self.dataArray[indexPath.section].workouts.isEmpty == true {
                        self.rootCollection.document(selectedDay).delete()
                        
                        self.loadData { (Bool) in
                            if Bool == true {
                                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                                tableView.deleteSections(indexSet, with: .automatic)
                                self.dayCounter = self.dataArray.count
                                tableView.reloadData()
                            }
                        }
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                    }
                    
                }
            }
            
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
