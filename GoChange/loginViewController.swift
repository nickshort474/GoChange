//
//  loginViewController.swift
//  GoChange
//
//  Created by Nick Short on 14/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class loginViewController:UIViewController,UITextFieldDelegate{
    
    var ref:Firebase!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var userID:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Firebase(url: "https://gochange.firebaseio.com/")
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        // check for svaed user id
        userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        print(userID)
        
        // check to see if has been saved and are already logged in
        //if(userID != nil){
           //
       // }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (userID != nil){
            segueToHomeScreen()
        }
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        let email = emailTextfield.text
        let password = passwordTextfield.text
        
        
        if email != nil && password != nil{
            ref.authUser(email, password: password, withCompletionBlock: {
                error, authData in
                
                if error != nil{
                    //TODO: code for error
                }else{
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid!,forKey:"uid")
                    self.segueToHomeScreen()
                    
                }
                
            })
        }else{
            //TODO: code for error
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToHomeScreen(){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
 
    
    
    
    
}