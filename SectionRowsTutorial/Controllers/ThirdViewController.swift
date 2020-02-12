//
//  ThirdViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 1/4/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit
import RealmSwift

class ThirdViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    var stats : Results<WeightSetsReps>?
    
    var historyTableView = UITableView()
    
    var weightTextField = UITextField()
    var weightLabel = UILabel()
    
    var notesTextView = UITextView()
    
    var repsTextField = UITextField()
    var repsLabel = UILabel()
    
    var timerTextField = UITextField()
    var timerImageView = UIImageView()
    let image1 = UIImage(named: "stopwatch")
    
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timeClock))
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    
    
    var timer = Timer()
    var timerDisplayed = 0
    
    let timePicker = UIPickerView()
    let timeSelect : [String] = ["300","240","180","120","90","60","45","30","15"]
    
    var nextSet = UIButton()
    var nextExcersise = UIButton()
    
    
    var selectedExercise : Exercises? {
        didSet{
            loadWsr()
        }
    }
    
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        notesTextView.delegate = self
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        timerTextField.delegate = self
        
        navConAcc()
        labelConfig()
        setTextFieldConstraints()
        setTextViewConstraints()
        setButtonConstraints()
        
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        let wsr = selectedExercise?.wsr[indexPath.row]
        
        cell.textLabel?.text = "Set \(indexPath.row + 1)   \(wsr!.weight.removeZerosFromEnd()) lbs - \(wsr!.reps.removeZerosFromEnd()) Reps"
        return cell
    }
    
    //MARK: - Swipe To Delete Functionality
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
    
    
    //MARK: - UILabel
    func labelConfig(){
        weightTextField.placeholder = "Total weight..."
        weightTextField.layer.borderWidth = 1
        weightTextField.backgroundColor = .white
        weightTextField.layer.cornerRadius = 25
        weightTextField.layer.borderColor = UIColor.lightGray.cgColor
        weightTextField.textColor = .black
        weightTextField.keyboardType = .decimalPad
        
        weightLabel.text = "  Weight (lbs): "
        weightLabel.textColor = .black
        
        weightTextField.leftView = weightLabel
        weightTextField.leftViewMode = .always
        
        
        repsTextField.placeholder = "Number of Reps..."
        repsTextField.layer.borderWidth = 1
        repsTextField.backgroundColor = .white
        repsTextField.layer.cornerRadius = 25
        repsTextField.layer.borderColor = UIColor.lightGray.cgColor
        repsTextField.textColor = .black
        repsTextField.keyboardType = .decimalPad
        
        
        repsLabel.text = "  Repetitions: "
        repsLabel.textColor = .black
        
        notesTextView.layer.borderWidth = 1
        notesTextView.backgroundColor = .white
        notesTextView.layer.cornerRadius = 25
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.text = "  Notes..."
        notesTextView.textColor = .black
        notesTextView.returnKeyType = .done
        
        
        repsTextField.leftView = repsLabel
        repsTextField.leftViewMode = .always
        
        nextSet.layer.borderWidth = 1
        nextSet.backgroundColor = .white
        nextSet.layer.cornerRadius = 25
        nextSet.layer.borderColor = UIColor.lightGray.cgColor
        nextSet.setTitle("Next Set", for: .normal)
        nextSet.setTitleColor(.black, for: .normal)
        nextSet.addTarget(self, action: #selector(addNewSet), for: .touchUpInside)
        
        nextExcersise.layer.borderWidth = 1
        nextExcersise.backgroundColor = .white
        nextExcersise.layer.cornerRadius = 25
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
        
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
        toolBar.barStyle = .default
        
        timerTextField.inputView = timePicker
        timerTextField.inputAccessoryView = toolBar
        timerTextField.placeholder = " Timer"
        
        [weightTextField, repsTextField, notesTextView, historyTableView, timerTextField, timerImageView].forEach{view.addSubview($0)}
    }
    
    
    //MARK: - Stopwatch
    @objc func timeClock(){
        
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
        } else {
            self.timer.invalidate()
            self.timerTextField.text = nil
            self.timerTextField.placeholder = " Timer"
        }
    }
    
    func resetTimer(){
        DispatchQueue.main.async {
            self.timer.invalidate()
            self.timerDisplayed = 0
            self.timerTextField.text = nil
            self.timerTextField.placeholder = " Timer"
        }
    }
    
    //MARK: - TextView Delegates
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
    
    //MARK: - Dismiss Keyboard Function
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    //MARK: - TextField Constrainst
    func setTextFieldConstraints(){
        weightTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 20, left: 40, bottom: 0, right: -40), size: .init(width: 0, height: 50))
        repsTextField.anchor(top: weightTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 30, left: 40, bottom: 0, right: -40) ,size: .init(width: 0, height: 50))
        timerTextField.anchor(top: repsTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 160, bottom: 0, right: -150), size: .init(width: 0, height: 50))
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
        print("Goes to next exercise...eventually")
    }
    
    //MARK: - UIButton and UITableView Constrainst
    func setButtonConstraints(){
        let buttonStackView = UIStackView(arrangedSubviews: [nextSet, nextExcersise])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 0, left: 15, bottom: 0, right: -15) ,size: .init(width: 0, height: 60))
        
        historyTableView.anchor(top: notesTextView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: buttonStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: -20, right: -20))
    }
    
    
    //MARK: - TextView Constraints
    func setTextViewConstraints(){
        notesTextView.anchor(top: timerTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: -40), size: .init(width: 0, height: 120))
    }
    
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        navigationItem.title = selectedExercise?.exerciseName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    //MARK: - Load Data
    func loadWsr() {
        stats = selectedExercise?.wsr.filter("TRUEPREDICATE")
        historyTableView.reloadData()
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
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

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
        timerDisplayed = Int(timeSelect[row])! + 1
    }
    
}

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
        if textField == timerTextField {
            resetTimer()
        }
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
