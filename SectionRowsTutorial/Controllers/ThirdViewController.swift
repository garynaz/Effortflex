//
//  ThirdViewController.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 1/4/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit
import RealmSwift

class ThirdViewController: UIViewController {
    
    let realm = try! Realm()
    
    var stats : Results<WeightSetsReps>?
    
    var weightTextField = UITextField()
    var weightLabel = UILabel()
    
    var repsTextField = UITextField()
    var repsLabel = UILabel()
    
    var timerImage = UIImageView()
    
    
    var selectedExercise : Exercises? {
        didSet{
            loadWsr()
        }
    }
    
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeClock()
        navConAcc()
        labelConfig()
        setTextFieldConstraints()
//        setImageViewConstraints()
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
        
        repsTextField.leftView = repsLabel
        repsTextField.leftViewMode = .always
        
        view.addSubview(weightTextField)
        view.addSubview(repsTextField)
    }
    
    //MARK: - TextField Constrainst
    func setTextFieldConstraints(){
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -650).isActive = true
        weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        weightTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        repsTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -550).isActive = true
        repsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        repsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        repsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: - ImageView Constraints
//    func setImageViewConstraints(){
//        timerImage.translatesAutoresizingMaskIntoConstraints = false
//
//        timerImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -450).isActive = true
//        timerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
//        timerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
//        timerImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
    
    
    
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        navigationItem.title = selectedExercise?.exerciseName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Stopwatch
    func timeClock(){
        let image1 = UIImage(named: "stopwatch")
        timerImage = UIImageView(image: image1)
        timerImage.frame = CGRect(x: 160, y: 350, width: 100, height: 110)
        timerImage.contentMode = .scaleAspectFit
        self.view.addSubview(timerImage)
    }
    
    //MARK: - Load Data
    func loadWsr() {
        stats = selectedExercise?.wsr.sorted(byKeyPath: "sets", ascending: true)
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
    }
    
    
    
    
    
    
}
