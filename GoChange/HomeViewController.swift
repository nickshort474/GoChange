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
    var ref:Firebase!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = Firebase(url:"https://GoChange.firebaseio.com")
        
        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        welcomeLabel.text = "Welcome to GoChange \(currentUserName)"
        
        
        //TODO: Check core data for amount of following
        followingLabel.hidden = true
        
        checkCoreData()
        
        let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }()
    
    
    @IBAction func createChange(sender: UIButton) {
        
        var controller:UINavigationController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("createChangeNavController") as! UINavigationController
        
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        
    }
    
    /*
    @IBAction func showfollowing(sender: UIButton) {
        
        var controller:FollowingViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    */
    
    @IBAction func addUserData(sender: UIButton) {
        
        var controller:UpdateUserInfoController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateUserInfoController") as! UpdateUserInfoController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func checkCoreData(){
        
        let request = NSFetchRequest(entityName: "Change")
        
        var results:[AnyObject]?
        
        do{
            results = try sharedContext.executeFetchRequest(request) as! [Change]
        }catch{
            //TODO: catch error
            print("error fetching")
        }
        
        let changeCount = results?.count
        let countText = String(changeCount!)
        
        
        if countText != "0"{
            followingLabel.hidden = false
            followingLabel.text = countText
        }else{
            followingLabel.hidden = true
        }
        
        
        
        
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


