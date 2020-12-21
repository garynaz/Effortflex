////
////  ThirdViewController.swift
////  SectionRowsTutorial
////
////  Created by Gary Naz on 1/4/20.
////  Copyright © 2020 Gari Nazarian. All rights reserved.
////
//
import UIKit
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import AVFoundation
import UserNotifications

class ThirdViewController: UIViewController, AVAudioPlayerDelegate {
    
    var exerciseIndex : Int = 1
    
    var historyTableView = UITableView()
    
    var weightTextField = UITextField()
    var repsTextField = UITextField()
    var timerTextField = UITextField()
    var notesTextField = UITextField()
    
    var weightLabel = UILabel()
    var repsLabel = UILabel()
    var notesLabel = UILabel()
    
    var nextSet = UIButton()
    var nextExcersise = UIButton()
    
    var timer = Timer()
    var timerDisplayed = 0
    let timePicker = UIPickerView()
    
    let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: 0, width: 60, height: 90))
    let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: 60, height: 90))
    let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
    let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timeClock))
    let cancelButton1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
    let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
    let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let timeSelect : [String] = ["300","240","180","120","90","60","45","30","15"]
    
    let image1 = UIImage(named: "stopwatch2")
    
    var audioPlayer : AVAudioPlayer!
    let soundURL = Bundle.main.url(forResource: "note1", withExtension: "wav")
    
    var wsrCollection : CollectionReference?
    var allExercises : [Exercise]?
    var selectedExercise : Exercise?
    var wsrArray : [Wsr] = []
    var indexToRemove : IndexPath?
    
    var feedback: ListenerRegistration?
    var authHandle : AuthStateDidChangeListenerHandle?
    
    var userIdRef = ""
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addBackground(image: "brickWall")
        
        conformance()
        labelConfig()
        classConstraints()
        
        historyTableView.register(WsrCell.self, forCellReuseIdentifier: "WsrCell")
    }
    
    //MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedExercise?.exercise
        
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.userIdRef = user!.uid
            self?.wsrCollection = Firestore.firestore().collection("/Users/\(self!.userIdRef)/WSR/")
            self?.loadWsr()
        }
    }
    
    //MARK: - viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authHandle!)
        feedback?.remove()
        wsrArray.removeAll()
    }
    
    //MARK: - DEINIT
    deinit {
        if feedback != nil {
            feedback!.remove()
        }
        print("OS reclaiming memory for Third VC")
    }
    
    //MARK: - Load Data
    func loadWsr() {
        feedback = self.wsrCollection!.whereField("Exercise", isEqualTo: selectedExercise!.exercise).order(by: "Timestamp", descending: false).addSnapshotListener({ (querySnapshot, err) in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    self.wsrArray.removeAll()
                    
                    for document in querySnapshot!.documents {
                        
                        let wsrData = document.data()
                        let weight = wsrData["Weight"] as! Double
                        let reps = wsrData["Reps"] as! Double
                        let notes = wsrData["Notes"] as! String
                        
                        let newWSR = Wsr(Day: self.selectedExercise!.day, Workout: self.selectedExercise!.workout, Exercise: self.selectedExercise!.exercise, Weight: weight, Reps: reps, Notes: notes, Key: document.reference)
                        self.wsrArray.append(newWSR)
                    }
                    
                    self.historyTableView.reloadData()
                }
                
                if (diff.type == .removed) {
                    print("Document Removed")
                    
                    self.historyTableView.performBatchUpdates({
                        self.historyTableView.deleteRows(at: [self.indexToRemove!], with: .fade)
                    }) { (done) in
                        self.historyTableView.reloadData()
                    }
                }
                
            }
            
            }
        )}
    
    //MARK: - Conforming the Delegate and Datasource
    func conformance(){
        notesTextField.delegate = self
        historyTableView.delegate = self
        historyTableView.dataSource = self
        timePicker.delegate = self
        timePicker.dataSource = self
        weightTextField.delegate = self
        repsTextField.delegate = self
        timerTextField.delegate = self
    }
    
    //MARK: - TextField and View Configuration
    func labelConfig(){
        weightTextField.attributedPlaceholder = NSAttributedString(string: "Total weight...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5843, green: 0.6471, blue: 0.651, alpha: 1.0)])
        weightTextField.backgroundColor = .darkGray
        weightTextField.layer.cornerRadius = 10
        weightTextField.textColor = .white
        weightTextField.inputAccessoryView = toolBar1
        weightTextField.keyboardType = .decimalPad
        weightTextField.leftView = weightLabel
        weightTextField.leftViewMode = .always
        weightTextField.tintColor = UIColor.clear
        
        weightLabel.text = "  Weight (lbs): "
        weightLabel.textColor = .white
        
        repsTextField.attributedPlaceholder = NSAttributedString(string: "Number of Reps...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5843, green: 0.6471, blue: 0.651, alpha: 1.0)])
        repsTextField.backgroundColor = .darkGray
        repsTextField.layer.cornerRadius = 10
        repsTextField.textColor = .white
        repsTextField.inputAccessoryView = toolBar1
        repsTextField.keyboardType = .decimalPad
        repsTextField.leftView = repsLabel
        repsTextField.leftViewMode = .always
        repsTextField.tintColor = UIColor.clear
        
        repsLabel.text = "  Repetitions: "
        repsLabel.textColor = .white
        
        notesTextField.backgroundColor = .darkGray
        notesTextField.layer.cornerRadius = 10
        notesTextField.textColor = .white
        notesTextField.inputAccessoryView = toolBar1
        notesTextField.keyboardType = .default
        notesTextField.tintColor = UIColor.clear
        notesTextField.leftView = notesLabel
        notesTextField.leftViewMode = .always
        
        notesLabel.text = "  Notes: "
        notesLabel.textColor = .white
        
        nextSet.backgroundColor = .darkGray
        nextSet.layer.cornerRadius = 10
        nextSet.setTitle("Next Set", for: .normal)
        nextSet.setTitleColor(.white, for: .normal)
        nextSet.addTarget(self, action: #selector(addNewSet), for: .touchUpInside)
        
        nextExcersise.backgroundColor = .darkGray
        nextExcersise.layer.cornerRadius = 10
        nextExcersise.setTitle("Next Exercise", for: .normal)
        nextExcersise.setTitleColor(.white, for: .normal)
        nextExcersise.addTarget(self, action: #selector(goToNextExercise), for: .touchUpInside)
        
        historyTableView.backgroundColor = UIColor.clear
        historyTableView.separatorStyle = .none
        
        addLeftImageTo(txtField: timerTextField, image: image1!)
        
        timerTextField.text = ""
        timerTextField.font = UIFont(name: "HelveticaNeue", size: 25)
        timerTextField.textColor = .black
        timerTextField.tintColor = UIColor.clear
        timerTextField.textAlignment = .left
        timerTextField.inputView = timePicker
        timerTextField.inputAccessoryView = toolBar2
        timerTextField.attributedPlaceholder = NSAttributedString(string: "   Timer", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
        
        toolBar1.sizeToFit()
        toolBar1.setItems([doneButton1, flexibleSpace1, cancelButton1], animated: false)
        toolBar1.barStyle = .default
        
        toolBar2.sizeToFit()
        toolBar2.setItems([doneButton2, flexibleSpace2, cancelButton2], animated: false)
        toolBar2.barStyle = .default
        
        [weightTextField, repsTextField, historyTableView, notesTextField, timerTextField].forEach{view.addSubview($0)}
    }
    
    
    //MARK: - Add Left Image to UITextField
    func addLeftImageTo(txtField: UITextField, image img: UIImage) {
        let height = 80.adjusted
        let wrapView = UIView(frame: CGRect(x: 0, y: 0, width: height-5.adjusted, height: height))
        
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height-8.adjusted, height: height))
        leftImageView.image = img
        leftImageView.contentMode = .scaleToFill
        wrapView.addSubview(leftImageView)
        
        txtField.addSubview(wrapView)
        txtField.leftView = wrapView
        txtField.leftViewMode = .always
    }
    
    //MARK: - Stopwatch Functionality
    @objc func timeClock(){
        let soundURL = Bundle.main.url(forResource: "note1", withExtension: "wav")
        do {audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)}
        catch{print(error)}
        
        timerDisplayed = self.timerDisplayed > 0 ? timerDisplayed : Int(timeSelect[0])!
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in }
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.badge = 1
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "note1.wav"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerDisplayed), repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        self.timerTextField.text = ("  \(String(self.timerDisplayed))")
        dismissKeyboard()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.Action), userInfo: nil, repeats: true)
        }
    }
    
    @objc func Action(){
        if timerDisplayed != 0 {
            DispatchQueue.main.async {
                self.timerDisplayed -= 1
                self.timerTextField.text = ("  \(String(self.timerDisplayed))")
            }
        }
        else {
            audioPlayer.play()
            self.timer.invalidate()
            self.timerTextField.text = nil
            self.timerTextField.placeholder = "   Timer"
        }
    }
    
    
    //MARK: - Dismiss Keyboard Function
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    //MARK: - UIButton Functions
    @objc func addNewSet(){
        let weight = Double(weightTextField.text!) ?? 0
        let reps = Double(repsTextField.text!) ?? 0
        let notes = notesTextField.text!
        
        wsrCollection?.addDocument(data: [
            "Weight" : weight,
            "Reps" : reps,
            "Notes" : notes,
            "Day" : selectedExercise!.day,
            "Workout" : selectedExercise!.workout,
            "Timestamp" : FieldValue.serverTimestamp(),
            "Exercise" : selectedExercise!.exercise
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("WSR added.")
            }
        }
        
    }
    
    @objc func goToNextExercise(){
        exerciseIndex = Int(allExercises!.firstIndex(of: selectedExercise!)! + 1)
        
        if  exerciseIndex <= allExercises!.count - 1 {
            selectedExercise = allExercises![exerciseIndex]
            navigationItem.title = selectedExercise?.exercise
            wsrArray.removeAll()
            historyTableView.reloadData()
            loadWsr()
            exerciseIndex += 1
        } else {
            let alert = UIAlertController(title: "Workout Completed", message: "Great job! Time to hit the showers!", preferredStyle: .alert)
            
            let finishedAction = UIAlertAction(title: "Done", style: .default)
            
            alert.addAction(finishedAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Third VC Constraints
    func classConstraints(){
        
        // UIButton and UITableView Constrainst
        let buttonStackView = UIStackView(arrangedSubviews: [nextSet, nextExcersise])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10.adjusted
        view.addSubview(buttonStackView)
        
        buttonStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15.adjusted, bottom: 20.adjusted, right: 15.adjusted) ,size: .init(width: 0, height: 60.adjusted))
        
        historyTableView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: buttonStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 20.adjusted, bottom: 20.adjusted, right: 20.adjusted), size: .init(width: 0, height: 180.adjusted))
        
        //UITextField Constrainst
        weightTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 60.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 50.adjusted))
        repsTextField.anchor(top: weightTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted) ,size: .init(width: 0, height: 50.adjusted))
        notesTextField.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: historyTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 40.adjusted, right: 40.adjusted) ,size: .init(width: 0, height: 60.adjusted))
        timerTextField.anchor(top: repsTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: notesTextField.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 50.adjusted, left: 100.adjusted, bottom: 50.adjusted, right: 100.adjusted))
    }
    
}

//MARK: - UIPickerView Methods
extension ThirdViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeSelect.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeSelect[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerDisplayed = Int(timeSelect[row])!
    }
    
}

//MARK: - UITextField Delegate Methods
extension ThirdViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if textField == notesTextField {
            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890. "
            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
            let typedCharsSet = CharacterSet(charactersIn: string)
            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 25 {
                return true
            }
        } else{
            let allowedChars = "1234567890. "
            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
            let typedCharsSet = CharacterSet(charactersIn: string)
            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 8 {
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        func resetTimer(){
            DispatchQueue.main.async {
                self.timer.invalidate()
                self.timerDisplayed = 0
                self.timerTextField.text = nil
                self.timerTextField.placeholder = "   Timer"
            }
        }
        
        if textField == timerTextField {
            resetTimer()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
}

//MARK: - TableView Methods
extension ThirdViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wsrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "WsrCell", for: indexPath)
        let wsr = wsrArray[indexPath.row]
        cell.textLabel?.text = "Set \(indexPath.row + 1)   \(wsr.weight.removeZerosFromEnd()) lbs - \(wsr.reps.removeZerosFromEnd()) Reps"
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        return cell
    }
    
    //Select Row To Display Notes For Selected Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notesTextField.text = wsrArray[indexPath.row].notes
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Swipe To Delete Functionality
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            indexToRemove = indexPath
            //Deletes WSR's...
            let selectedWSR = wsrArray[indexPath.row].key!
            
            wsrCollection!.document(selectedWSR.documentID).delete()
            wsrArray.remove(at: indexPath.row)
        }
    }
}
