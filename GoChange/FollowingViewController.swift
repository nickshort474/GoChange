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
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all core data saved changes
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            //TODO: deal with errors
        }
        
        
        
    }
    @IBAction func homeButtonClick(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        print("home clicked")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let object = fetchedResultsController.objectAtIndexPath(indexPath) as! Change
        
        cell.textLabel?.text = object.changeName
        cell.detailTextLabel!.text = object.changeDescription
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var controller:CreateChangeViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        
        let navigationController = self.navigationController
        
        controller.sendingController = "following"
        
        
        let changeClicked = fetchedResultsController.objectAtIndexPath(indexPath) as! Change
        
        
        controller.isOwner = changeClicked.owner 
        controller.changeID = changeClicked.changeID
        
        
        navigationController?.pushViewController(controller,animated: true)
    
    
    
    
    }
    
   
}


