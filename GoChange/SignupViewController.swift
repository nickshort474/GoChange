//
//  SignupViewController.swift
//  GoChange
//
//  Created by Nick Short on 20/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class SignupViewController:UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var ref = Firebase(url:"https://gochange.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        
    }
    
    
    @IBAction func signupButton(sender: UIButton) {
        
        
        print("signing up")
        
        let username = usernameTextfield.text
        let email = emailTextfield.text
        let password = passwordTextfield.text
        
        
        if username != "" && email != "" && password != ""{
            
            // create user account
            ref.createUser(email, password: password, withValueCompletionBlock: {
                error, result in
                
                if error != nil{
                    //TODO: code for error
                    print("error creating user \(error)")
                }else{
                    
                    //authorize user
                    self.ref.authUser(email,password: password, withCompletionBlock: {
                        error, authData in
                        
                        if error != nil{
                            print("error auth \(error)")
                        }else{
                        
                            //create basic user details
                            let user = ["provider":authData.provider!,"email":email!,"username":username!]
                        
                            // create new user location in database
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid!).setValue(user)
                        
                            // save user id to NSDefaults
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid!, forKey: "uid")
                        
                            // segue to home view controller
                            var controller:HomeViewController
                            controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                            self.presentViewController(controller, animated: true, completion: nil)
                        }
                        
                    })
                }
            })
        }else{
            //TODO: code for no username, password, email filled in
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
}


