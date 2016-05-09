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
    @IBOutlet weak var startActivityIndicator: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = Firebase(url:"https://gochange.firebaseio.com")
        
        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        welcomeLabel.text = "Welcome to GoChange \(currentUserName)"
        
        
        //TODO: Check core data for amount of following
        followingLabel.hidden = true
        startActivityIndicator.hidden = true
        startActivityIndicator.stopAnimating()
        
        let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        checkCoreData()
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }()
    
    
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
    
    
    
    
    
    
    @IBAction func addUserData(sender: UIButton) {
        
        var controller:UpdateUserInfoController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateUserInfoController") as! UpdateUserInfoController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func checkCoreData(){
        
        let request = NSFetchRequest(entityName: "Problem")
        
        var results:[AnyObject]?
        
        do{
            results = try sharedContext.executeFetchRequest(request) as! [Problem]
        }catch{
            //TODO: catch error
            print("error fetching")
        }
        
        let problemCount = results?.count
        let countText = String(problemCount!)
        
        
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


