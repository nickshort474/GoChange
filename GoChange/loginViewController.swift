//
//  loginViewController.swift
//  GoChange
//
//  Created by Nick Short on 14/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase


class loginViewController:UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var ref:FIRDatabaseReference!
    var userID:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        //set delegates and UI elements
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        loginActivityIndicator.hidden = true
        loginActivityIndicator.stopAnimating()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        //check for saved user ID in user defaults if exists log in
        userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        
        if (userID != nil){
            
            segueToHomeScreen()
            
        }
        
        loginButton.enabled = true
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        
        loginActivityIndicator.hidden = false
        loginActivityIndicator.startAnimating()
        self.view.alpha = 0.5
        loginButton.enabled = false
        
        
        let email = emailTextfield.text
        let password = passwordTextfield.text
        
        //check for empty fields
        if(email != "" && password != ""){
            
            //sign in with email to Firebase
            FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: {
                user,error in
                
                // if error comes back
                if error != nil{
                    
                    self.loginActivityIndicator.hidden = true
                    self.loginActivityIndicator.stopAnimating()
                    self.view.alpha = 1
                    self.loginButton.enabled = true
                    
                     // check for type of error and present alert accordingly
                    switch error!.localizedDescription{
                        case "An internal error has occurred, print and inspect the error details for more information.":
                        self.presentAlert("Please enter a valid email")
                        
                        case "There is no user record corresponding to this identifier. The user may have been deleted":
                        self.presentAlert("Email not recognized, please re-enter email or sign-up")
                        
                        case "The password is invalid or the user does not have a password.":
                        self.presentAlert("Password is incorrect, please enter a valid password")
                        
                        case "(Error Code: NETWORK_ERROR) The request timed out.":
                        self.presentAlert("Login timed out, please check your network connection")
                        
                        default:
                        break
                        
                    }
                    
                 // if no error
                }else{
                    
                    // set username to returned user uid
                    let usernameRef = self.ref.child("users/\(user!.uid)")
                    
                    
                    usernameRef.observeEventType(.Value, withBlock: {snapshot in
                        
                        //get 
                        let username = snapshot.value!.objectForKey("username") as? String
                        
                        NSUserDefaults.standardUserDefaults().setValue(user!.uid,forKey:"uid")
                        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
                        
                        self.segueToHomeScreen()
                        
                    }, withCancelBlock: { error in
                         print(error.description)
                    })
                }
            })
        }else{
            //code for empty fields
            presentAlert("Please provide your email and password")
            self.loginActivityIndicator.hidden = true
            self.loginActivityIndicator.stopAnimating()
            self.view.alpha = 1
            self.loginButton.enabled = true
            
        }
    }
    
    
    //segue to Signup screen
    @IBAction func signupControl(sender: UIButton) {
        
        var controller:SignupViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
    //resign responders
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    
    
    func segueToHomeScreen(){
        
        //segue to home screen
        loginActivityIndicator.hidden = true
        loginActivityIndicator.stopAnimating()
        self.view.alpha = 1
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
 
    
    
    @IBAction func forgotPassword(sender: UIButton) {
        
        let emailText = emailTextfield.text!
        
        if emailText == ""{
            presentAlert("Please enter email")
        }else{
            FIRAuth.auth()?.sendPasswordResetWithEmail(emailText, completion:{
                error in
                if let error = error{
                    print(error)
                }else{
                    self.presentAlert("Password reset email sent")
                }
                
                
            })
        }
        
        
    }
    
    
    
    //present alerts
    func presentAlert(alertType:String){
        
        let controller = UIAlertController()
        controller.message = alertType
        
        let alertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel){
            action in
            
            
        }
        
        controller.addAction(alertAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
}