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
    
    var notesTextView = UITextView()
    
    var repsTextField = UITextField()
    var repsLabel = UILabel()
    
    var timerImage = UIImageView()
    
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
        
        timeClock()
        navConAcc()
        labelConfig()
        setTextFieldConstraints()
        setImageViewConstraints()
        setTextViewConstraints()
        setButtonConstraints()
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
        notesTextView.text = "Notes"
        notesTextView.textAlignment = .center
        
        
        repsTextField.leftView = repsLabel
        repsTextField.leftViewMode = .always
        
        nextSet.layer.borderWidth = 1
        nextSet.backgroundColor = .white
        nextSet.layer.cornerRadius = 25
        nextSet.layer.borderColor = UIColor.lightGray.cgColor
        nextSet.setTitle("Next Set", for: .normal)
        nextSet.setTitleColor(.black, for: .normal)
        
        nextExcersise.layer.borderWidth = 1
        nextExcersise.backgroundColor = .white
        nextExcersise.layer.cornerRadius = 25
        nextExcersise.layer.borderColor = UIColor.lightGray.cgColor
        nextExcersise.setTitle("Next Exercise", for: .normal)
        nextExcersise.setTitleColor(.black, for: .normal)
        
        [weightTextField, repsTextField, notesTextView, nextSet, nextExcersise].forEach{view.addSubview($0)}

    }
    
    //MARK: - TextField Constrainst
    func setTextFieldConstraints(){
        weightTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 40, bottom: 0, right: -40), size: .init(width: 0, height: 50))
        repsTextField.anchor(top: weightTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 40, bottom: 0, right: -40) ,size: .init(width: 0, height: 50))
    }
    
    //MARK: - UIButton Constrainst
    func setButtonConstraints(){
        nextSet.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 40, bottom: 0, right: -150), size: .init(width: 120, height: 70))
        nextExcersise.anchor(top: nil, leading: nextSet.trailingAnchor, bottom: nextSet.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 85, bottom: 0, right: -40), size: .init(width: 120, height: 70))
       }
    
    
    //MARK: - ImageView Constraints
    func setImageViewConstraints(){
        timerImage.anchor(top: repsTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 100))
    }
    
    //MARK: - TextView Constraints
    func setTextViewConstraints(){
        notesTextView.anchor(top: timerImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: -40), size: .init(width: 100, height: 110))
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
