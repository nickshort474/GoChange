//
//  FollowingViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData

class FollowingViewController: UITableViewController,
 NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var followingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all core data saved changes
        
        //followingTableView.delegate = self
        followingTableView.backgroundColor = UIColor.whiteColor()
        self.definesPresentationContext = true
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            //TODO: deal with errors
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
          return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    lazy var fetchedResultsController:NSFetchedResultsController = {
       
        var fetchRequest = NSFetchRequest(entityName: "Change")
        fetchRequest.sortDescriptors = []
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    
    override func numberOfSectionsInTableView(tableView:UITableView) -> Int{
        
        return self.fetchedResultsController.sections!.count
        
    }
    
    override func tableView(tableView:UITableView,numberOfRowsInSection section:Int) -> Int{
        
        let sectionInfo = fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
        
    }
    
    override func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var object = fetchedResultsController.objectAtIndexPath(indexPath) as! Change
        
        cell.textLabel?.text = object.changeName
        
        
        cell.detailTextLabel!.text = object.changeDescription
        
        return cell
    }
    
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("following")
    }
    
    
    
    @IBAction func HomeButtonClick(sender: UIButton) {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func FollowedChangeButton(sender: UIButton) {
        
        var controller:CreateChangeViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        
        let navigationController = self.navigationController
        
        controller.sendingController = "following"
        controller.isOwner = "yes"
        
        navigationController?.pushViewController(controller,animated: true)
        
    }
}


