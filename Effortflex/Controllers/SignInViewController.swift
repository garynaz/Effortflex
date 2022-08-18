//
//  LoginViewController.swift
//  Effortflex
//
//  Created by Gary Naz on 2/29/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import GoogleSignIn

class SignInViewController: UIViewController {

    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
	var forgotPasswordButton = UIButton()
    var errorLabel = UILabel()
    var loginStackView = UIStackView()
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addBackground(image: "gloves")
        buttonConfig()
        textFieldConstraints()
    }
    
    //MARK: - DEINIT
    deinit {
        print("OS reclaiming memory for SignIn VC")
    }
    
    //MARK: - Configure TextFields
    func buttonConfig(){
        emailTextField.setLeftPaddingPoints(25)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "   Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.setLeftPaddingPoints(25)
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "   Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

		forgotPasswordButton.setTitle("Forget Password?", for: .normal)
		forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
		forgotPasswordButton.addTarget(self, action: #selector(goToPasswordRecoveryVC), for: .touchUpInside)
        
        errorLabel.text = ""
        errorLabel.textAlignment = .center
        errorLabel.alpha = 0
        errorLabel.numberOfLines = 0
        
        loginStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        loginStackView.axis = .vertical
        loginStackView.distribution = .fillEqually
        loginStackView.spacing = 20.adjusted
                
        [loginStackView, errorLabel].forEach{view.addSubview($0)}
    }
    
    //MARK: - TextField Constraints
    func textFieldConstraints(){
        loginStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 150.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 200.adjusted))
        
        errorLabel.anchor(top: loginStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted))
    }
       
    
    //MARK: Login Validation
    func validateField() -> String?{
           if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               
               return "Please fill in all fields."
           }
                      
           return nil
       }
    
    @objc func loginTapped(){
        
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                }
                else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    //MARK: - Transition to First VC.
    func transitionToHome(){
        let navController = UINavigationController(rootViewController: FirstViewController())
        let homeViewController = navController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

	@objc func goToPasswordRecoveryVC(){
		navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
	}
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

}
