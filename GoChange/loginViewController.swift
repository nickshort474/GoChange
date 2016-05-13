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
    
    var ref:Firebase!
    var userID:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = Firebase(url: "https://gochange.firebaseio.com/")
        
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
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        loginActivityIndicator.hidden = false
        loginActivityIndicator.startAnimating()
        self.view.alpha = 0.5
        loginButton.enabled = false
        
        
        let email = emailTextfield.text
        let password = passwordTextfield.text
        
        
        if(email != "" && password != ""){
            
            ref.authUser(email, password: password, withCompletionBlock: {
                error, authData in
                
                if error != nil{
                    //TODO: code for error
                    
                    self.loginActivityIndicator.hidden = true
                    self.loginActivityIndicator.stopAnimating()
                    self.view.alpha = 1
                    self.loginButton.enabled = true

                    
                    switch error.localizedDescription{
                        case "(Error Code: INVALID_EMAIL) The specified email address is invalid.":
                        self.presentAlert("Please enter a valid email")
                        
                        case "(Error Code: INVALID_USER) The specified user does not exist.":
                        self.presentAlert("Email not recognized, please re-enter email or sign-up")
                        
                        case "(Error Code: INVALID_PASSWORD) The specified password is incorrect.":
                        self.presentAlert("Password is incorrect, please enter a valid password")
                        
                        case "(Error Code: NETWORK_ERROR) The request timed out.":
                        self.presentAlert("Login timed out, please check your network connection")
                        
                        default:
                        break
                        
                    }
                    
                    
                }else{
                    
                    let usernameRef = self.ref.childByAppendingPath("users/\(authData.uid!)")
                    
                    usernameRef.observeEventType(.Value, withBlock: {snapshot in
                        
                        let username = snapshot.value.objectForKey("username") as? String
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid!,forKey:"uid")
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
 
    
    //present alerts
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