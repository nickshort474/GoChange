//
//  UpdateUserInfoController.swift
//  GoChange
//
//  Created by Nick Short on 06/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class UpdateUserInfoController:UIViewController{
    
    var ref = Firebase(url:"https://gochange.firebaseio.com")
    
    
    
    var currentlyUpdating:String = ""
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func updatePassword(sender: UIButton) {
        currentlyUpdating = "password"
        segueToInput()
    }
    
    @IBAction func updateUsername(sender: UIButton) {
        currentlyUpdating = "username"
        segueToInput()
    }
    
    
    @IBAction func updateEmail(sender: UIButton) {
        currentlyUpdating = "email"
        segueToInput()
    }
    
    func segueToInput(){
        var controller:SignupViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        controller.sendingController = "update"
        controller.updateField = currentlyUpdating
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
  
    
    @IBAction func cancelUpdate(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}