//
//  HomeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var startActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        //set title bar with user name
        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        welcomeLabel.text = "Welcome to GoChange \(currentUserName)"
        
        //hide activtiy indicator
        followingLabel.hidden = true
        startActivityIndicator.hidden = true
        startActivityIndicator.stopAnimating()
        
        //set back buttons to home
        let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //check core data for number of followed problems to dsiplay
        checkCoreData()
    }
    
    
    //create reference to managed object context
    lazy var sharedContext:NSManagedObjectContext = {
        
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }()
    
    
    
    //segue to create new problem screen
    @IBAction func createProblem(sender: UIButton) {
        
        self.startActivityIndicator.hidden = false
        self.startActivityIndicator.startAnimating()
        self.view.alpha = 0.5
        
        
        var controller:UINavigationController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("createProblemNavController") as! UINavigationController
        
        
        self.presentViewController(controller, animated: true, completion: {
            self.startActivityIndicator.hidden = true
            self.startActivityIndicator.stopAnimating()
            self.view.alpha = 1
        })
        
        
    }
    
    
    //segue to Update user detail screen
    @IBAction func addUserData(sender: UIButton) {
        
        var controller:UpdateUserInfoController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateUserInfoController") as! UpdateUserInfoController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    //check core data for problem numbers
    func checkCoreData(){
        
        //setup request
        let request = NSFetchRequest(entityName: "Problem")
        var results:[AnyObject]?
        
        //execute request and store in results
        do{
            results = try sharedContext.executeFetchRequest(request) as! [Problem]
        }catch{
            
        }
        
        //get count
        let problemCount = results?.count
        let countText = String(problemCount!)
        
        //set following label to number of problems
        if countText != "0"{
            followingLabel.hidden = false
            followingLabel.text = countText
        }else{
            followingLabel.hidden = true
        }
        
    }
    
    
    @IBAction func logout(sender: UIButton) {
        //unauthorize user
        //ref.unauth()
        try! FIRAuth.auth()?.signOut()
        
        //remove user details from user defaults
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "username")
        
        //dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
}


