//
//  FollowingViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData

class FollowingViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all core data saved problems
        do{
            try fetchedResultsController.performFetch()
        }catch{
        }
        
        let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
       self.navigationController?.navigationBar.barTintColor = GoChangeClient.Constants.customOrangeColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.followingTableView.reloadData()
    }
    
    
    @IBAction func homeButtonClick(sender: UIButton) {
       
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // get reference to managed object context
    lazy var sharedContext:NSManagedObjectContext = {
          return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    //setup fetched results controller
    lazy var fetchedResultsController:NSFetchedResultsController = {
       
        var fetchRequest = NSFetchRequest(entityName: "Problem")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        let object = fetchedResultsController.objectAtIndexPath(indexPath) as! Problem
        
        cell.problemName.text = object.problemName
        cell.ownerName.text = "By: \(object.problemOwner)"
        cell.voteCount.text = String(object.solutionCount)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var controller:ViewFollowingViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewFollowingViewController") as! ViewFollowingViewController
        
        let navigationController = self.navigationController
        controller.problemClicked = fetchedResultsController.objectAtIndexPath(indexPath) as! Problem
        controller.sendingController = "Following"
        
        navigationController?.pushViewController(controller,animated: true)
    
    
    
    
    }
    
   
}


