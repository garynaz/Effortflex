//
//  AuthenticationViewController.swift
//  Effortflex
//
//  Created by Gary Naz on 2/29/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

   let loginButton = UIButton()
   let signUpButton = UIButton()
   var authStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConfig()
        buttonConstraints()
            
    }
    
    //MARK: - Button Customization
    func buttonConfig(){
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        signUpButton.addTarget(self, action: #selector(goToSignupVC), for: .touchUpInside)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        authStackView = UIStackView(arrangedSubviews: [loginButton, signUpButton])
        authStackView.axis = .vertical
        authStackView.distribution = .fillEqually
        authStackView.spacing = 20.adjusted
        
        view.addSubview(authStackView)
    }
    
    //MARK: - Button Constraints
    func buttonConstraints(){
        authStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 40.adjusted, right: 40.adjusted))
    }
    
    
    @objc func goToSignupVC(){
        let destinationVC = SignUpViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    @objc func goToLoginVC(){
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }

}
