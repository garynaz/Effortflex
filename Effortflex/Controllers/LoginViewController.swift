//
//  LoginViewController.swift
//  Effortflex
//
//  Created by Gary Naz on 2/29/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var errorLabel = UILabel()
    
    var loginStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConfig()
        textFieldConstraints()
        view.backgroundColor = UIColor.white

    }
    
    //MARK: - Configure TextFields
    func buttonConfig(){
        
        emailTextField.placeholder = "   Email Address"
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordTextField.placeholder = "   Password"
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        
        errorLabel.text = ""
        errorLabel.textAlignment = .center
        errorLabel.alpha = 0
        
        loginStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, errorLabel])
        loginStackView.axis = .vertical
        loginStackView.distribution = .fillEqually
        loginStackView.spacing = 20.adjusted
                
        view.addSubview(loginStackView)
        
    }
    
    //MARK: - TextField Constraints
    func textFieldConstraints(){
        loginStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 200))
    }
    
    
    func authenticate(){
        let alert = UIAlertController(title: "ERROR", message: "Error details", preferredStyle: .alert)
        
        let finishedAction = UIAlertAction(title: "Dismiss", style: .default)
        
        alert.addAction(finishedAction)
        present(alert, animated: true, completion: nil)
    }



}
