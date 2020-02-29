//
//  ThirdViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 1/4/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import UserNotifications

class ThirdViewController: UIViewController {
    
    let realm = try! Realm()
    
    var stats : Results<WeightSetsReps>?
    var allExercises : Results<Exercises>?

    // Exercise Index value needs to equal Index value of selected workout exercise...
    var exerciseIndex : Int = 1
    
    var historyTableView = UITableView()
    
    var weightTextField = UITextField()
    var repsTextField = UITextField()
    var timerTextField = UITextField()

    var notesTextView = UITextView()
    
    var weightLabel = UILabel()
    var repsLabel = UILabel()
    
    var nextSet = UIButton()
    var nextExcersise = UIButton()
    
    
    var timer = Timer()
    var timerDisplayed = 0
    let timePicker = UIPickerView()
    let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timeClock))
    let timeSelect : [String] = ["300","240","180","120","90","60","45","30","15"]
    
    let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))

    var timerImageView = UIImageView()
    let image1 = UIImage(named: "stopwatch")
    
    var audioPlayer : AVAudioPlayer?
    let soundURL = Bundle.main.url(forResource: "note1", withExtension: "wav")

    
    var selectedExercise : Exercises? {
        didSet{
            loadWsr()
        }
    }
    

    
//MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        conformance()
        navConAcc()
        labelConfig()
        classConstraints()
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    
//MARK: - Conforming the Delegate and Datasource
    func conformance(){
        notesTextView.delegate = self
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        timerTextField.delegate = self
    }
    
//MARK: - UILabel
    func labelConfig(){
        weightTextField.placeholder = "Total weight..."
        weightTextField.layer.borderWidth = 1
        weightTextField.backgroundColor = .white
        weightTextField.layer.cornerRadius = 10
        weightTextField.layer.borderColor = UIColor.lightGray.cgColor
        weightTextField.textColor = .black
        weightTextField.inputAccessoryView = toolBar2
        weightTextField.keyboardType = .decimalPad
        weightTextField.leftView = weightLabel
        weightTextField.leftViewMode = .always
        
        weightLabel.text = "  Weight (lbs): "
        weightLabel.textColor = .black
        
        repsTextField.placeholder = "Number of Reps..."
        repsTextField.layer.borderWidth = 1
        repsTextField.backgroundColor = .white
        repsTextField.layer.cornerRadius = 10
        repsTextField.layer.borderColor = UIColor.lightGray.cgColor
        repsTextField.textColor = .black
        repsTextField.inputAccessoryView = toolBar2
        repsTextField.keyboardType = .decimalPad
        repsTextField.leftView = repsLabel
        repsTextField.leftViewMode = .always

        repsLabel.text = "  Repetitions: "
        repsLabel.textColor = .black

        notesTextView.layer.borderWidth = 1
        notesTextView.backgroundColor = .white
        notesTextView.layer.cornerRadius = 25
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.text = "  Notes..."
        notesTextView.textColor = .black
        notesTextView.returnKeyType = .done

        
        nextSet.layer.borderWidth = 1
        nextSet.backgroundColor = .white
        nextSet.layer.cornerRadius = 10
        nextSet.layer.borderColor = UIColor.lightGray.cgColor
        nextSet.setTitle("Next Set", for: .normal)
        nextSet.setTitleColor(.black, for: .normal)
        nextSet.addTarget(self, action: #selector(addNewSet), for: .touchUpInside)

        nextExcersise.layer.borderWidth = 1
        nextExcersise.backgroundColor = .white
        nextExcersise.layer.cornerRadius = 10
        nextExcersise.layer.borderColor = UIColor.lightGray.cgColor
        nextExcersise.setTitle("Next Exercise", for: .normal)
        nextExcersise.setTitleColor(.black, for: .normal)
        nextExcersise.addTarget(self, action: #selector(goToNextExercise), for: .touchUpInside)


        historyTableView.backgroundColor = .white
        historyTableView.separatorStyle = .none
        
        timerImageView.image = image1
        timerTextField.text = ""
        timerTextField.leftViewMode = .always
        timerTextField.leftView = timerImageView
        timerTextField.textColor = .black
        timerTextField.tintColor = UIColor.clear
        timerTextField.textAlignment = .left
        timerTextField.inputView = timePicker
        timerTextField.inputAccessoryView = toolBar1
        timerTextField.placeholder = " Timer"
        
        toolBar1.sizeToFit()
        toolBar1.setItems([doneButton1], animated: false)
        toolBar1.barStyle = .default
        
        toolBar2.sizeToFit()
        toolBar2.setItems([doneButton2], animated: false)
        toolBar2.barStyle = .default
        
        [weightTextField, repsTextField, historyTableView, notesTextView, timerTextField].forEach{view.addSubview($0)}
    }
    
    
//MARK: - Stopwatch Functionality
    @objc func timeClock(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in }
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.badge = 1
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "note1.wav"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerDisplayed), repeats: false)
        print(TimeInterval(timerDisplayed))
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
            self.timer.invalidate()
            self.timerTextField.text = nil
            self.timerTextField.placeholder = " Timer"
        }
    }
    
    
//MARK: - Dismiss Keyboard Function
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
//MARK: - UIButton Functions
    @objc func addNewSet(){
        let newSet = WeightSetsReps()
        newSet.weight = Double(weightTextField.text!) ?? 0
        newSet.reps = Double(repsTextField.text!) ?? 0
        try! realm.write {
            selectedExercise?.wsr.append(newSet)
            loadWsr()
        }
    }
    
    @objc func goToNextExercise(){
        exerciseIndex = Int(allExercises!.index(of: selectedExercise!)! + 1)

        if  exerciseIndex <= allExercises!.count - 1 {
            selectedExercise = allExercises![exerciseIndex]
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
        
        buttonStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15.adjusted, bottom: 0, right: 15.adjusted) ,size: .init(width: 0, height: 60.adjusted))
        
        historyTableView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: buttonStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 20.adjusted, bottom: 20.adjusted, right: 20.adjusted), size: .init(width: 0, height: 180))

    //UITextField Constrainst
        weightTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 50.adjusted))
        repsTextField.anchor(top: weightTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted) ,size: .init(width: 0, height: 50.adjusted))
        timerTextField.anchor(top: repsTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: notesTextView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20.adjusted, left: 150.adjusted, bottom: 20.adjusted, right: 140.adjusted))
        
    //UITextView Constraints
        notesTextView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: historyTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 20.adjusted, right: 40.adjusted) ,size: .init(width: 0, height: 100.adjusted))
    }
    
    
//MARK: - UINavigation Bar Setup
    func navConAcc(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
//MARK: - Load Data
    func loadWsr() {
        stats = selectedExercise?.wsr.filter("TRUEPREDICATE")
        historyTableView.reloadData()
        navigationItem.title = selectedExercise?.exerciseName
    }
    
//MARK: - Save Data
    func save(wsr : WeightSetsReps){
        do {
            try realm.write {
                realm.add(wsr)
            }
        } catch {
            print("Error saving wsr data \(error)")
        }
        self.loadWsr()
    }
    
}


//MARK: - Constraints Extensions
    extension UIView {
        func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
            
            translatesAutoresizingMaskIntoConstraints = false
            
            if let top = top {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            }
            
            if let leading = leading {
                leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            }
            
            if let bottom = bottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
            }
            
            if let trailing = trailing {
                trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
            }
            
            if size.width != 0 {
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            
            if size.height != 0 {
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
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
            
            let allowedChars = "1234567890. "
            let allowedCharSet = CharacterSet(charactersIn: allowedChars)
            let typedCharsSet = CharacterSet(charactersIn: string)
            if allowedCharSet.isSuperset(of: typedCharsSet) && newLength <= 10 {
                return true
            }
            return false
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {

            func resetTimer(){
                DispatchQueue.main.async {
                    self.timer.invalidate()
                    self.timerDisplayed = 0
                    self.timerTextField.text = nil
                    self.timerTextField.placeholder = " Timer"
                }
            }

            if textField == timerTextField {
                resetTimer()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
    }


//MARK: - Extension for Double (Remove Trailing Zeroes)
    extension Double {
        func removeZerosFromEnd() -> String {
            let formatter = NumberFormatter()
            let number = NSNumber(value: self)
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
            return String(formatter.string(from: number) ?? "")
        }
    }


//MARK: - TableView Methods
    extension ThirdViewController:  UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return stats?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
            let wsr = selectedExercise?.wsr[indexPath.row]
            
            cell.textLabel?.text = "Set \(indexPath.row + 1)   \(wsr!.weight.removeZerosFromEnd()) lbs - \(wsr!.reps.removeZerosFromEnd()) Reps"
            return cell
        }
        
        //Swipe To Delete Functionality
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                
                try! realm.write {
                    tableView.performBatchUpdates({
                        self.realm.delete((self.selectedExercise?.wsr[indexPath.row])!)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }) { (done) in
                        tableView.reloadData()
                    }
                }
                
            }
        }
    }


//MARK: - TextView Delegates
    extension ThirdViewController: UITextViewDelegate {
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "  Notes..." {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
            }
            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                notesTextView.text = "  Notes..."
                notesTextView.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
