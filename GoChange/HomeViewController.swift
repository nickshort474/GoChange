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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Firebase(url:"https://GoChange.firebaseio.com")
        
        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        welcomeLabel.text = "Welcome \(currentUserName)"
        
        
        
    }
    
    @IBAction func addUserData(sender: UIButton) {
        // get userID
        
        let controller = UIAlertController()
        controller.title = "Update your user information"
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        let alertAction = UIAlertAction(title: "Add data", style: UIAlertActionStyle.Default, handler: {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        controller.addAction(alertAction)
        
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid")
        
        
        let userRef = ref.childByAppendingPath("users/\(userID)")
        
        let usersNewUsername = ""
        
        let values = ["username":usersNewUsername]
        
        userRef.updateChildValues(values)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    @IBAction func logout(sender: UIButton) {
        
        ref.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "username")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


