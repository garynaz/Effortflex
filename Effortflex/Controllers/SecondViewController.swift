////
////  SecondViewController.swift
////  SectionRowsTutorial
////
////  Created by Gary Naz on 12/29/19.
////  Copyright © 2019 Gari Nazarian. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class SecondViewController: UITableViewController {
//
//    let realm = try! Realm()
//
//    var textField1 = UITextField()
//
//    var exercises : Results<Exercises>?
//
//    weak var buttonActionToEnable: UIAlertAction?
//
//    var selectedWorkout : Workouts? {
//        didSet{
//            loadExercises()
//        }
//    }
//
//
////MARK: - viewDidLoad()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
//        tableView.tableFooterView = UIView()
//        navConAcc()
//
//    }
//
////MARK: - viewWillAppear()
//    override func viewWillAppear(_ animated: Bool) {
//        let backgroundImage = UIImage(named: "db2")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFill
//        imageView.alpha = 0.5
//
//        tableView.backgroundView = imageView
//    }
//
////MARK: - Navigation Bar Setup
//    func navConAcc(){
//        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise))
//        navigationItem.title = selectedWorkout?.title
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = addBarButton
//    }
//
//// MARK: - TableView Data Source
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return exercises?.count ?? 0
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
//
//        let exercise = selectedWorkout?.exercise[indexPath.row]
//
//        cell.textLabel?.text = "\(exercise!.exerciseName)"
//        cell.accessoryType = .disclosureIndicator
//        cell.layer.backgroundColor = UIColor.clear.cgColor
//        cell.textLabel?.textColor = UIColor(red: 0.1333, green: 0.2863, blue: 0.4, alpha: 1.0)
//        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let destinationVC = ThirdViewController()
//        destinationVC.selectedExercise = exercises![indexPath.row]
//        destinationVC.allExercises = exercises
//
//        tableView.deselectRow(at: indexPath, animated: true )
//
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//
//
////MARK: - Add a New Exercise
//    @objc func addExercise() {
//
//        let alert = UIAlertController(title: "New Exercise", message: "Please name your Exercise...", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
//            alert.dismiss(animated: true, completion: nil)
//        }
//        let addAction = UIAlertAction(title: "Add Exercise", style: .default) { (UIAlertAction) in
//            //Add Exercise to database.
//            //Append exercise to selected workout object.
//            let exercise = Exercises()
//            exercise.exerciseName = self.textField1.text!
//            try! self.realm.write {
//                self.selectedWorkout?.exercise.append(exercise)
//                self.loadExercises()
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
//
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//
//    }
//
//    @objc func textFieldChanged(_ sender: Any) {
//        let textfield = sender as! UITextField
//        self.buttonActionToEnable!.isEnabled = textfield.text!.count > 0 && String((textfield.text?.prefix(1))!) != " "
//    }
//
////MARK: - Swipe to Delete
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            try! realm.write {
//                realm.delete((selectedWorkout?.exercise[indexPath.row].wsr)!)
//                realm.delete((selectedWorkout?.exercise[indexPath.row])!)
//
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                tableView.endUpdates()
//            }
//        }
//    }
//
//
////MARK: - Load Data
//    func loadExercises() {
//        exercises = selectedWorkout?.exercise.filter(("TRUEPREDICATE"))
//        tableView.reloadData()
//    }
//
////MARK: - Save Data
//    func save(newExercise : Exercises) {
//        do {
//            try realm.write {
//                realm.add(newExercise)
//            }
//        } catch {
//            print("Error saving Exercise \(error)")
//        }
//        self.loadExercises()
//    }
//
//
//}
//
////MARK: - Textfield Delegate Methods
//    extension SecondViewController : UITextFieldDelegate {
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//            guard let text = textField.text else { return true }
//            let newLength = text.count + string.count - range.length
//
//            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
//            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
//            let typedCharsSet = CharacterSet(charactersIn: string)
//            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 21 {
//                return true
//            }
//            return false
//        }
//    }
