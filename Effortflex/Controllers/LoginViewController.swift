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

class LoginViewController: UIViewController {
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    var authStackView = UIStackView()
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    
    var line1 = UIView()
    var line2 = UIView()
    var lineText = UILabel()
    var lineStackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundVideo()
        buttonConfig()
        handleGoogleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.borderWidth = 0.5
        signUpButton.layer.cornerRadius = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.addTarget(self, action: #selector(goToSignupVC), for: .touchUpInside)
        
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        authStackView = UIStackView(arrangedSubviews: [loginButton, signUpButton])
        authStackView.axis = .vertical
        authStackView.distribution = .fillEqually
        authStackView.spacing = 20.adjusted
        
        line1.backgroundColor = .white
        line2.backgroundColor = .white
        lineText.textColor = .white
        lineText.text = "OR"
        
        line1.translatesAutoresizingMaskIntoConstraints = false
        line2.translatesAutoresizingMaskIntoConstraints = false
        lineText.translatesAutoresizingMaskIntoConstraints = false
        
        
        line1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line1.widthAnchor.constraint(equalToConstant: 100).isActive = true

        line2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 100).isActive = true

        lineText.heightAnchor.constraint(equalToConstant: 25).isActive = true
        lineText.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        lineStackView.distribution = .equalCentering
        lineStackView.axis  = .horizontal
        lineStackView.spacing = 20
        lineStackView.alignment = .center
        
        [line1, lineText, line2].forEach{lineStackView.addArrangedSubview($0)}
        view.addSubview(lineStackView)
        
        view.addSubview(authStackView)
    }
    
    func handleGoogleSignIn(){
        let googleLoginButton = GIDSignInButton()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        googleLoginButton.colorScheme = .dark
        view.addSubview(googleLoginButton)
        view.bringSubviewToFront(googleLoginButton)
        
        
        authStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: lineStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 580, left: 40.adjusted, bottom: 0, right: 40.adjusted))
        
        lineStackView.anchor(top: authStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: googleLoginButton.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 0, right: 40.adjusted))
        
        googleLoginButton.anchor(top: lineStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 20, right: 40.adjusted))
    }
    
    
    @objc func goToSignupVC(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        
    }
    
    @objc func goToLoginVC(){
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    
    func playBackgroundVideo(){
        guard let path = Bundle.main.path(forResource: "dumbbells2480", ofType: "mov") else { return }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = self.view.frame
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        NotificationCenter.default.addObserver(self,selector: #selector(playItem),name: UIApplication.willEnterForegroundNotification, object: nil)
        
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true

        view.bringSubviewToFront(authStackView)
    }
    
    @objc func playerItemDidReachEnd(){
        player!.seek(to: CMTime.zero)
    }
    
    @objc private func playItem() {
      playerItemDidReachEnd()
      player?.play()

      if let playerlayer = playerLayer {
        view.layer.insertSublayer(playerlayer, at: 0)
      }
    }
    
}
