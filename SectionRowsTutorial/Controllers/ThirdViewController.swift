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
    
    var selectedExercise : Exercises? {
        didSet{
            loadWsr()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navConAcc()
        
        view.backgroundColor = .red
    }
    
    //MARK: - Navigation Bar Setup
    func navConAcc(){
        navigationItem.title = selectedExercise?.exerciseName
        navigationController?.navigationBar.prefersLargeTitles = true
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
