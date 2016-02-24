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
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    var ref = Firebase(url:"https://gochange.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        //TODO: if segue from add User data (update) switch signupButton.text = "Update user info"
        
        //TODO: write second function to updateChildValues
        
    }
    
    
    @IBAction func signupButton(sender: UIButton) {
        
        // if signupButton.text == "Update"{
            // updateChildValues()
        //}
    
        
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
                            NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
                            
                            
                            // segue back to loginViewController
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        
                    })
                }
            })
        }else{
            //TODO: code for no username, password, email filled in
            
        }
    }
    
    func updateChildValues(){
        
        //1. gather current user details and paste into boxes
        
        
        
        
        
        //2. on button click...
        // update username (plus any future other details) in database
        
        
        //update email, password in database && in security
        
        
        // self.dismissViewController(true,completion:nil)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
}


