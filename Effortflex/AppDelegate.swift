//
//  AppDelegate.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 12/8/19.
//  Copyright © 2019 Gari Nazarian. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
       if let window = window {
            let navController = UINavigationController(rootViewController: LoginViewController())
            window.backgroundColor = UIColor.white
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    

    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)


    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }

    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.endBackgroundUpdateTask()
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func transitionToHome(){
        let navController = UINavigationController(rootViewController: FirstViewController())
        let homeViewController = navController
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
                
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            print("Google user is signed in \(String(describing: authResult?.user.uid))")
            
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
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
}


