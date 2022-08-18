//
//  ForgotPasswordViewController.swift
//  Effortflex
//
//  Created by Gary Naz on 8/12/22.
//  Copyright © 2022 Gari Nazarian. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import UIKit

class ForgotPasswordViewController: UIViewController {

	var viewTitle = UILabel()
	var recoverEmailDescription = UITextView()
	var emailRecovertTextField = UITextField()
	var resetPasswordButton = UIButton()
	var recoveryStackView = UIStackView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		view.addBackground(image: "gloves")
		viewConfig()
		textFieldConstraints()
	}

	func viewConfig() {
		viewTitle.text = "Forgot Password"
		viewTitle.font = .systemFont(ofSize: 30)
		viewTitle.textAlignment = .center

		recoverEmailDescription.text = "Please enter the email you used at the time of registration to receive the password reset instructions."
		recoverEmailDescription.textAlignment = .center
		recoverEmailDescription.backgroundColor = .clear

		emailRecovertTextField.setLeftPaddingPoints(25)
		emailRecovertTextField.layer.borderWidth = 0.5
		emailRecovertTextField.layer.cornerRadius = 1
		emailRecovertTextField.layer.borderColor = UIColor.white.cgColor
		emailRecovertTextField.attributedPlaceholder = NSAttributedString(string: "   Please enter in your email...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

		resetPasswordButton.setTitle("Reset Password", for: .normal)
		resetPasswordButton.setTitleColor(.systemBlue, for: .normal)
		resetPasswordButton.addTarget(self, action: #selector(sendPasswordRecoveryInstruction), for: .touchUpInside)

		recoveryStackView = UIStackView(arrangedSubviews: [viewTitle, recoverEmailDescription, emailRecovertTextField, resetPasswordButton])
		recoveryStackView.axis = .vertical
		recoveryStackView.distribution = .fillEqually
		recoveryStackView.spacing = 20.adjusted

		view.addSubview(recoveryStackView)
	}

	//MARK: - TextField Constraints
	func textFieldConstraints(){
		recoveryStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 150.adjusted, left: 40.adjusted, bottom: 0, right: 40.adjusted), size: .init(width: 0, height: 200.adjusted))
	}

	@objc func sendPasswordRecoveryInstruction() {

		Auth.auth().sendPasswordReset(withEmail: emailRecovertTextField.text ?? "") { error in
			if let error = error {
				let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
				let finishedAction = UIAlertAction(title: "OK", style: .default)
				alert.addAction(finishedAction)
				self.present(alert, animated: true, completion: nil)
			} else {
				let alert = UIAlertController(title: "Password Recovery", message: "A password recovery email has been sent successfully!", preferredStyle: .alert)
				let finishedAction = UIAlertAction(title: "OK", style: .default) {_ in
					_ = self.navigationController?.popToRootViewController(animated: true)
				}
				alert.addAction(finishedAction)
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	

}
