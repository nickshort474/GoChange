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
    
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        //set delegates
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        //if segue from add User data (update) switch signupButton.text = "Update user info"
        if (sendingController == "update"){
            
            signupButton.setTitle("Update user info", forState: UIControlState.Normal)
            
            //set labels accordingly
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
            }else if(updateField == "delete"){
                label1.text = "Email"
                label2.text = "Password"
                
                label3.hidden = true
                passwordTextfield.hidden = true
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
                        FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: {
                            error, result in
                
                            if error != nil{
                               
                               //present error alert
                               self.presentAlert("Error creating new user, please try again")
                                
                            }else{
                                
                                //authorize user
                                FIRAuth.auth()?.signInWithEmail(email!,password: password!, completion: {
                                     user,error in
                        
                                    if error != nil{
                                        //present error alert
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
                
                //migrating from firebase 2.0 to 3.0 no longer need password? / need to update UI
                _ = passwordTextfield.text
            
                //update user defaults
                NSUserDefaults.standardUserDefaults().setValue(newUsername, forKey: "username")
            
                let values = ["username":newUsername]
            
                let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
                let userRef = ref.child("users/\(userID!)")
            
                userRef.observeEventType(.Value, withBlock: { snapshot in
                
                    let usernameValue = snapshot.value!.objectForKey("username") as? String
                    
                    if usernameValue == oldUsername{
                        userRef.updateChildValues(values)
                    }
                    self.presentAlert("Username changed!")
                })
            
            
            
            }else if(updateField == "password"){
                
                
                let email = usernameTextfield.text! //email
                let oldPassword = emailTextfield.text! // old password
                let newPassword = passwordTextfield.text!  // new password
                
                let user = FIRAuth.auth()?.currentUser
                
                var credential:FIRAuthCredential
                credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: oldPassword)
                
                user?.reauthenticateWithCredential(credential){
                    error in
                    
                    if let _ = error{
                        
                    }else{
                        
                        user?.updatePassword(newPassword, completion:{
                            error in
                            if let _ = error{
                                 //code for error
                                self.presentAlert("There was an error while changing password, please try again")
                                
                            }else{
                                self.presentAlert("password changed!")
                                
                            }
                            
                        })
                    }
                }
                
        }else if(updateField == "email"){
            
            let oldEmail = usernameTextfield.text! // old email
            let newEmail = emailTextfield.text! // new email
            let password = passwordTextfield.text! // password
            
            let user = FIRAuth.auth()?.currentUser
            var credential:FIRAuthCredential
            credential = FIREmailPasswordAuthProvider.credentialWithEmail(oldEmail, password: password)
                
            user?.reauthenticateWithCredential(credential){
                error in
                    
                if let error = error{
                        
                    print("an error happened \(error)")
                        
                }else{
                    user?.updateEmail(newEmail, completion: {
                        error in
                        if let _ = error{
                            self.presentAlert("There was an error while changing email, please try again")
                            
                        }else{
                            // save new email to database
                            self.ref.child("users/(user!.uid)/email").setValue(newEmail)
                            
                            //present alert
                            self.presentAlert("Email changed!")
                        }
                    })
                }
            }
        }else if(updateField == "delete"){
                
                let email = usernameTextfield.text! // email
                let password = emailTextfield.text! // password
                
                
                let user = FIRAuth.auth()?.currentUser
                var credential:FIRAuthCredential
                credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: password)
                
                user?.reauthenticateWithCredential(credential){
                    error in
                    
                    if let error = error{
                        
                        print("an error happened \(error)")
                        
                    }else{
                        user?.deleteWithCompletion({
                            error in
                            if let _ = error{
                           
                                self.presentAlert("There was an error while deleting account")
                               
                            }else{
                                self.presentAlert("Account deleted")
                            }
                        })
                    }
                }
    
                
                
        }
        }else{
            //prompt user to input data
            self.presentAlert("Please input information")
        }
        
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
        
        let alertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel){
            action in
            
            if alertType == "Account deleted"{
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        controller.addAction(alertAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}


