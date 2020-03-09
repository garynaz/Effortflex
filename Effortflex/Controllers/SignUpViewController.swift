//
//  SignUpViewController.swift
//  
//
//  Created by Gary Naz on 2/29/20.
//

import UIKit

class SignUpViewController: UIViewController {

    var fNameTextField = UITextField()
    var lNameTextField = UITextField()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var signUpButton = UIButton()
    
    var signUpStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonConfig()
        textFieldConstraints()
        view.backgroundColor = UIColor.white

    }
    

    //MARK: - Configure TextFields
    func buttonConfig(){
        
        fNameTextField.placeholder = "   First Name"
        fNameTextField.layer.borderWidth = 1
        fNameTextField.layer.cornerRadius = 10
        fNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        lNameTextField.placeholder = "   Last Name"
        lNameTextField.layer.borderWidth = 1
        lNameTextField.layer.cornerRadius = 10
        lNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        emailTextField.placeholder = "   Email address"
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordTextField.placeholder = "   Password"
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.isSecureTextEntry = true
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        
        signUpStackView = UIStackView(arrangedSubviews: [fNameTextField, lNameTextField, emailTextField, passwordTextField, signUpButton])
        signUpStackView.axis = .vertical
        signUpStackView.distribution = .fillEqually
        signUpStackView.spacing = 20.adjusted
                
        view.addSubview(signUpStackView)
        
    }
    
    
    //MARK: - TextField Constraints
    func textFieldConstraints(){
        signUpStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 300))
    }
    
    
    func authenticate(){
        let alert = UIAlertController(title: "ERROR", message: "Error details", preferredStyle: .alert)
        
        let finishedAction = UIAlertAction(title: "Dismiss", style: .default)
        
        alert.addAction(finishedAction)
        present(alert, animated: true, completion: nil)
    }
    


}
