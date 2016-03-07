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
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    
    
    var sendingController:String = ""
    var updateField:String = ""
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    var ref = Firebase(url:"https://gochange.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        
        //TODO: if segue from add User data (update) switch signupButton.text = "Update user info"
        if (sendingController == "update"){
            signupButton.setTitle("Update user info", forState: UIControlState.Normal)
            
            if(updateField == "username"){
                label1.text = "Old username"
                label2.text = "New username"
                label3.text = "Password"
            }else if(updateField == "password"){
                label1.text = "Email"
                label2.text = "Old password"
                label3.text = "New password"
            }else if(updateField == "email"){
                label1.text = "Old email"
                label2.text = "New email"
                label3.text = "Password"
            }
            
            
            
            
        }else if (sendingController == "login"){
            signupButton.setTitle("Signup", forState: UIControlState.Normal)
            
            
        }
        
    }
    
    
    @IBAction func signupButton(sender: UIButton) {
        
        
        if signupButton.currentTitle == "Update user info"{
            updateChildValues()
        }else{
        
        
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
            print("no information, please put user information")
        }
        }
    }
    
    
    func updateChildValues(){
        
        //1. gather current user details and paste into boxes
        print("update child values")
        
        if usernameTextfield.text != nil && emailTextfield.text != nil && passwordTextfield.text != nil{
        
        
        if(updateField == "username"){
            let oldUsername = usernameTextfield.text
            let newUsername = emailTextfield.text!
            let password = passwordTextfield.text
            
            NSUserDefaults.standardUserDefaults().setValue(newUsername, forKey: "username")
            
            let values = ["username":newUsername]
            
            
            let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
            var userRef = ref.childByAppendingPath("users/\(userID!)")
            print(userRef)
            
            userRef.observeEventType(.Value, withBlock: { snapshot in
                
                let usernameValue = snapshot.value.objectForKey("username") as? String
                if usernameValue == oldUsername{
                    userRef.updateChildValues(values)
                }
            })
            
            
            
        }else if(updateField == "password"){
            let email = usernameTextfield.text
            let oldPassword = emailTextfield.text
            let newPassword = passwordTextfield.text
            
            ref.changePasswordForUser(email, fromOld: oldPassword, toNew: newPassword, withCompletionBlock: { error in
                if error != nil{
                    //TODO: code for error
                    print("there was an error!")
                }else{
                    print("password changed!")
                }
                
            })
            
            
            
        }else if(updateField == "email"){
            let oldEmail = usernameTextfield.text
            let newEmail = emailTextfield.text
            let password = passwordTextfield.text
            
            ref.changeEmailForUser(oldEmail, password: password, toNewEmail: newEmail, withCompletionBlock: { error in
                if error != nil{
                    //TODO: process error
                    print("there was an error")
                }else{
                    print("email updated!")
                }
            })
        }
        
        
        
        }else{
            //TODO: prompt user to input data
            print("please input data")
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}


