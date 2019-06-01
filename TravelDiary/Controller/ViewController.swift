//
//  ViewController.swift
//  TravelDiary
//
//  Created by Heeral on 5/28/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = DataController.shared().Google_Client_ID
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Do any additional setup after loading the view.
        signInButton.center = view.center
    }
    
    
    @IBAction func signInTabbed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            //TODO show alert for login failed
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            print(user.profile.email!)
            print(user.profile.givenName!)
            performSegue(withIdentifier: "successfullLogin", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        //GIDSignIn.sharedInstance()?.signOut()
        
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
