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
import GoogleSignIn


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
        view.backgroundColor = UIColor.white
        view.addBackground(image: "gloves")
        buttonConfig()
        textFieldConstraints()
    }
    
    
    
    //MARK: - Configure TextFields
    func buttonConfig(){
        
        fNameTextField.attributedPlaceholder = NSAttributedString(string: "   First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        fNameTextField.placeholder = "   First Name"
        fNameTextField.layer.borderWidth = 0.5
        fNameTextField.layer.cornerRadius = 1
        fNameTextField.layer.borderColor = UIColor.white.cgColor
        fNameTextField.attributedPlaceholder = NSAttributedString(string: "   First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        lNameTextField.placeholder = "   Last Name"
        lNameTextField.layer.borderWidth = 0.5
        lNameTextField.layer.cornerRadius = 1
        lNameTextField.layer.borderColor = UIColor.white.cgColor
        lNameTextField.attributedPlaceholder = NSAttributedString(string: "   First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailTextField.placeholder = "   Email address"
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "   First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.placeholder = "   Password"
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "   First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.borderWidth = 0.5
        signUpButton.layer.cornerRadius = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        
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
                    
                    db.collection("Users").document("\(result!.user.uid)").setData(["firstName":firstName, "lastName":lastName, "uid":result!.user.uid]){ (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }else{
                            self.transitionToHome()
                        }
                    }
                                    
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
        signUpStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 150.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 300))
        
        errorLabel.anchor(top: signUpStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted))
    }
    
    
    func transitionToHome(){
        let navController = UINavigationController(rootViewController: FirstViewController())
        let homeViewController = navController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}
