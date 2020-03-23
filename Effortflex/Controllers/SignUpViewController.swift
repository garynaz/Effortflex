//
//  SignUpViewController.swift
//  
//
//  Created by Gary Naz on 2/29/20.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift


class SignUpViewController: UIViewController {

    var fNameTextField = UITextField()
    var lNameTextField = UITextField()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var signUpButton = UIButton()
    var errorLabel = UILabel()
    
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
        
        errorLabel.text = ""
        errorLabel.textAlignment = .center
        errorLabel.alpha = 0
        errorLabel.numberOfLines = 0
        
        signUpStackView = UIStackView(arrangedSubviews: [fNameTextField, lNameTextField, emailTextField, passwordTextField, signUpButton])
        signUpStackView.axis = .vertical
        signUpStackView.distribution = .fillEqually
        signUpStackView.spacing = 20.adjusted
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
                
        [signUpStackView, errorLabel].forEach{view.addSubview($0)}
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passwordTest.evaluate(with: password)
    }
    
    
    func validateField() -> String?{
        
        if  fNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword!) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    @objc func signUpTapped(){
        
        let error = validateField()
        
        if error != nil {
            showError(error!)
        } else {
            
            let firstName = fNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Error creating user")
                }
                else {
                    
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid":result!.user.uid])
                    { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    self.transitionToHome()
                                    
                }
            }
            
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    //MARK: - TextField Constraints
    func textFieldConstraints(){
        signUpStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 300))
        
        errorLabel.anchor(top: signUpStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted))
    }
    
    
    func transitionToHome(){
        let homeViewController = FirstViewController()
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    


}
