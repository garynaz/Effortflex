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
import FBSDKLoginKit
import AVFoundation

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    let googleLoginButton = GIDSignInButton()
    let fBLoginButton = FBLoginButton()
    let loginButton = UIButton()
    let signUpButton = UIButton()
    
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    var line1 = UIView()
    var line2 = UIView()
    var lineText = UILabel()
    
    var authStackView = UIStackView()
    var lineStackView = UIStackView()
    var fbGoogleStackView = UIStackView()
    
    
    var custGoogleButton = UIButton()
    var googleIcon = UIImage(named: "googleicon")
    var googleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    var custFbButton = UIButton()
    var fbIcon = UIImage(named: "facebookicon")
    var fbImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    var socialStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundVideo()
        buttonConfig()
        constraints()
        handleFacebookGoogleLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar

        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
    }
    
    
    //MARK: - Button Customization
    func buttonConfig(){
               
        loginButton.setTitle("SIGN IN", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.borderWidth = 0.5
        signUpButton.layer.cornerRadius = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.addTarget(self, action: #selector(goToSignupVC), for: .touchUpInside)
        
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
        line1.widthAnchor.constraint(equalToConstant: 120).isActive = true

        line2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line2.widthAnchor.constraint(equalToConstant: 120).isActive = true

        lineText.heightAnchor.constraint(equalToConstant: 25).isActive = true
        lineText.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        lineStackView.distribution = .equalCentering
        lineStackView.axis  = .horizontal
        lineStackView.spacing = 20.adjusted
        lineStackView.alignment = .center
        
        fbGoogleStackView = UIStackView(arrangedSubviews: [googleLoginButton, fBLoginButton])
        fbGoogleStackView.distribution = .fillEqually
        fbGoogleStackView.axis = .horizontal
        fbGoogleStackView.spacing = 20.adjusted
        fbGoogleStackView.alignment = .center
        
        fbImgView.image = fbIcon!
        custFbButton.addSubview(fbImgView)
        custFbButton.layer.borderWidth = 0.5
        custFbButton.layer.borderColor = UIColor.white.cgColor
        custFbButton.layer.cornerRadius = 1
        custFbButton.setTitle("FACEBOOK", for: .normal)
        
        googleImageView.image = googleIcon!
        custGoogleButton.addSubview(googleImageView)
        custGoogleButton.layer.borderWidth = 0.5
        custGoogleButton.layer.borderColor = UIColor.white.cgColor
        custGoogleButton.layer.cornerRadius = 1
        custGoogleButton.setTitle("GOOGLE", for: .normal)
        
        [custFbButton, custGoogleButton].forEach{socialStackView.addArrangedSubview($0)}
        socialStackView.distribution = .fillEqually
        socialStackView.axis = .horizontal
        socialStackView.spacing = 20.adjusted
        socialStackView.alignment = .center
        view.addSubview(socialStackView)
        
        
        [line1, lineText, line2].forEach{lineStackView.addArrangedSubview($0)}
        view.addSubview(lineStackView)
        view.addSubview(authStackView)
        view.addSubview(fbGoogleStackView)
        view.addSubview(custGoogleButton)
        view.addSubview(custFbButton)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if (error == nil){
            if result!.isCancelled{
                return
            }
        }
        if let error = error{
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Unable to login to Facebook: error [\(error)]")
                return
            }
            print("Facebook user is signed in \(String(describing: authResult?.user.uid))")
            
            let db = Firestore.firestore()
            
            db.collection("Users").document("\(authResult!.user.uid)").setData(["uid":authResult!.user.uid]){ (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }else{
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome(){
        let navController = UINavigationController(rootViewController: FirstViewController())
        let homeViewController = navController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func handleFacebookGoogleLogin(){
        fBLoginButton.delegate = self
        fBLoginButton.permissions = ["email"]
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        googleLoginButton.colorScheme = .dark
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print("Facebook user is signed out")
    }
    
    func constraints(){
        
//        custGoogleButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 50.adjusted, left: 100.adjusted, bottom: 0, right: 100.adjusted))
//
//        custFbButton.anchor(top: custGoogleButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 50.adjusted, left: 100.adjusted, bottom: 0, right: 100.adjusted))
//
//
//        googleImageView.anchor(top: custGoogleButton.topAnchor, leading: custGoogleButton.leadingAnchor, bottom: custGoogleButton.bottomAnchor, trailing: nil, size: .init(width: 40.adjusted, height: 40.adjusted))
//
//        fbImgView.anchor(top: custFbButton.topAnchor, leading: custFbButton.leadingAnchor, bottom: custFbButton.bottomAnchor, trailing: nil, size: .init(width: 40.adjusted, height: 40.adjusted))
        
        
        socialStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40))
        
        
        authStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: lineStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 10.adjusted, right: 40.adjusted))
        
        lineStackView.anchor(top: authStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: fbGoogleStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 0, right: 40.adjusted))
        
        fbGoogleStackView.anchor(top: lineStackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 40.adjusted, bottom: 20.adjusted, right: 40.adjusted))
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
