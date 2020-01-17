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
    
    var timerImage = UIImageView()
    
    var nextSet = UIButton()
    var nextExcersise = UIButton()
                
    var counter = 0
    
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
        
        timeClock()
        navConAcc()
        labelConfig()
        setTextFieldConstraints()
        setImageViewConstraints()
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
        counter = (selectedExercise?.wsr[indexPath.row].counter)!
        counter += 1
        cell.textLabel?.text = "Set \(wsr!.sets)   \(wsr!.weight) lbs - \(wsr!.reps) Reps"
        
        return cell
    }
    
    
    //MARK: - UILabel
    func labelConfig(){
        weightTextField.placeholder = "Total weight..."
        weightTextField.layer.borderWidth = 1
        weightTextField.backgroundColor = .white
        weightTextField.layer.cornerRadius = 25
        weightTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        weightLabel.text = "  Weight (lbs): "
        weightLabel.textColor = .black
        
        weightTextField.leftView = weightLabel
        weightTextField.leftViewMode = .always
        
        
        repsTextField.placeholder = "Number of Reps..."
        repsTextField.layer.borderWidth = 1
        repsTextField.backgroundColor = .white
        repsTextField.layer.cornerRadius = 25
        repsTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        repsLabel.text = "  Repetitions: "
        repsLabel.textColor = .black
        
        notesTextView.layer.borderWidth = 1
        notesTextView.backgroundColor = .white
        notesTextView.layer.cornerRadius = 25
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.text = "  Notes..."
        notesTextView.textColor = UIColor.lightGray
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
        
        [weightTextField, repsTextField, notesTextView, historyTableView].forEach{view.addSubview($0)}
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
    }
    
    //MARK: - UIButton Functions
    @objc func addNewSet(){
        let newSet = WeightSetsReps()
        newSet.counter = counter
        newSet.sets = newSet.counter
        newSet.weight = Int(weightTextField.text!) ?? 0
        newSet.reps = Int(repsTextField.text!) ?? 0
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
        buttonStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 60))
        
        historyTableView.anchor(top: notesTextView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: buttonStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: -20, right: -20))
    }
    
    //MARK: - ImageView Constraints
    func setImageViewConstraints(){
        timerImage.anchor(top: repsTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 80))
    }
    
    //MARK: - TextView Constraints
    func setTextViewConstraints(){
        notesTextView.anchor(top: timerImage.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: -40), size: .init(width: 0, height: 120))
    }
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        navigationItem.title = selectedExercise?.exerciseName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Stopwatch
    func timeClock(){
        let image1 = UIImage(named: "stopwatch")
        timerImage = UIImageView(image: image1)
        timerImage.contentMode = .scaleAspectFit
        
        self.view.addSubview(timerImage)
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
