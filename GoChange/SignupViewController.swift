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
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var sendingController:String = ""
    var updateField:String = ""
    //var ref = Firebase(url:"https://gochange.firebaseio.com")
    
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        //if segue from add User data (update) switch signupButton.text = "Update user info"
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
        
        //check for network connection
        _ = CheckForNetwork(){
            result in
            
            //If network connection exists signup or update
            if(result == "Connected"){
                
                if(self.signupButton.currentTitle == "Update user info"){
                    
                    self.updateChildValues()
                    
                }else{
                    
                    //gather user data
                    let username = self.usernameTextfield.text
                    let email = self.emailTextfield.text
                    let password = self.passwordTextfield.text
                    
                    //test for empty fields
                    if (username != "" && email != "" && password != ""){
            
                        // create user account
                        //self.ref.createUser
                        
                        FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: {
                            error, result in
                
                            if error != nil{
                                
                               self.presentAlert("Error creating new user, please try again")
                                
                            }else{
                                
                                //authorize user
                                //self.ref.authUser
                                FIRAuth.auth()?.signInWithEmail(email!,password: password!, completion: {
                                     user,error in
                        
                                    if error != nil{
                                        self.presentAlert("error authorizing user, please try again")
                                    }else{
                        
                                        //create basic user details
                                        let provider = user?.providerID
                                        
                                        let userDetails = ["provider":provider!, "email":email!, "username":username!]
                                        
                                        // create new user location in database
                                        self.ref.child("users").child(user!.uid).setValue(userDetails)
                        
                                        // save user id to NSDefaults
                                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                                        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
                            
                            
                                        // segue back to loginViewController
                                        self.dismissViewControllerAnimated(true, completion: nil)
                            
                                    }
                                })
                            }
                        })
                    }else{
                        //code for no username, password, email filled in
                        self.presentAlert("Please put user information")
                    }
                }
            }else{
                self.presentAlert("Cannot signup, please check your network connection and try again")
            }
        }
    }
    
    
    func updateChildValues(){
        
        //gather current user details and paste into boxes
        if(usernameTextfield.text != nil && emailTextfield.text != nil && passwordTextfield.text != nil){
        
            if(updateField == "username"){
                let oldUsername = usernameTextfield.text
                let newUsername = emailTextfield.text!
                _ = passwordTextfield.text
            
                NSUserDefaults.standardUserDefaults().setValue(newUsername, forKey: "username")
            
                let values = ["username":newUsername]
            
                let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
                let userRef = ref.child("users/\(userID!)")
            
                userRef.observeEventType(.Value, withBlock: { snapshot in
                
                    let usernameValue = snapshot.value!.objectForKey("username") as? String
                    if usernameValue == oldUsername{
                        userRef.updateChildValues(values)
                    }
                })
            
            
            
            }else if(updateField == "password"){
                _ = usernameTextfield.text
                _ = emailTextfield.text
                let newPassword = passwordTextfield.text
            
                let user = FIRAuth.auth()?.currentUser
                
                user?.updatePassword(newPassword!, completion:{ error in
                    if error != nil{
                        
                        //code for error
                        self.presentAlert("There was an error while changing password, please try again")
                        
                    }else{
                       self.presentAlert("password changed!")
                    }
                })
                
        }else if(updateField == "email"){
            
            _ = usernameTextfield.text
            let newEmail = emailTextfield.text
            _ = passwordTextfield.text
            
            let user = FIRAuth.auth()?.currentUser
                
            user?.updateEmail(newEmail!, completion: {
                error in
                if error != nil{
                    //TODO: process error
                    self.presentAlert("There was an error while changing email, please try again")
                }else{
                    self.presentAlert("Email changed!")
                }
            })
        }
        }else{
            //prompt user to input data
            self.presentAlert("Please input information")
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
    
    
    
    func presentAlert(alertType:String){
        
        let controller = UIAlertController()
        controller.message = alertType
        
        let alertAction = UIAlertAction(title: "Please try again", style: UIAlertActionStyle.Cancel){
            action in
            
        }
        
        controller.addAction(alertAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}


