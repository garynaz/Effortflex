//
//  AuthenticationViewController.swift
//  Effortflex
//
//  Created by Gary Naz on 2/29/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AVFoundation

class MainViewController: UIViewController {
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    var authStackView = UIStackView()
    var player : AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfig()
        buttonConstraints()
        handleGoogleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playBackgroundVideo()
        let navigationBar = self.navigationController?.navigationBar

        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let navigationBar = self.navigationController?.navigationBar

        navigationBar?.shadowImage = nil
        navigationBar?.setBackgroundImage(nil, for: .default)
        navigationBar?.isTranslucent = false
    }
    
    //MARK: - Button Customization
    func buttonConfig(){
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        signUpButton.addTarget(self, action: #selector(goToSignupVC), for: .touchUpInside)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        authStackView = UIStackView(arrangedSubviews: [loginButton, signUpButton])
        authStackView.axis = .vertical
        authStackView.distribution = .fillEqually
        authStackView.spacing = 20.adjusted
        
        view.addSubview(authStackView)
    }
    
    func handleGoogleSignIn(){
        let loginButton = GIDSignInButton()
        loginButton.colorScheme = .dark
        view.addSubview(loginButton)
        loginButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10.adjusted, left: 10.adjusted, bottom: 0.adjusted, right: 10.adjusted))
        GIDSignIn.sharedInstance()?.presentingViewController = self
        view.bringSubviewToFront(loginButton)
    }
    
    //MARK: - Button Constraints
    func buttonConstraints(){
        authStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 40.adjusted, right: 40.adjusted))
    }
    
    
    @objc func goToSignupVC(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        
    }
    
    @objc func goToLoginVC(){
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    
    func playBackgroundVideo(){
        guard let path = Bundle.main.path(forResource: "dumbbells2480", ofType: "mov") else { return }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true

        view.bringSubviewToFront(authStackView)
    }
    
    @objc func playerItemDidReachEnd(){
        player!.seek(to: CMTime.zero)
    }
    
}
