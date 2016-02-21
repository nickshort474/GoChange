//
//  HomeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase



class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
   
    var ref:Firebase!
    //let currentUserName = GoChangeClient.Constants.userName
    //let currentUserID = GoChangeClient.Constants.userID
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Firebase(url:"https://GoChange.firebaseio.com")
        
        
        //welcomeLabel.text = "\(currentUserName)" + " " + "\(currentUserID)"
        //print(currentUserID)
        
    }
    
    @IBAction func addUserData(sender: UIButton) {
        
        let userData =  ["email":"myEmail","provider":"Postman"]
        
        var ref = Firebase(url:"https://GoChange.firebaseio.com/")
        
        print(ref)
        var userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        var userRef = ref.childByAppendingPath("users/")
        
        print(userRef)
        
        var currentUserRef = userRef.childByAppendingPath(userID)
        
        print(currentUserRef)
        
        currentUserRef.setValue(userData)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    @IBAction func logout(sender: UIButton) {
        
        ref.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


