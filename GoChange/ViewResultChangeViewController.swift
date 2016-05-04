//
//  ViewResultChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 15/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class ViewResultChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var solutionTable: UITableView!
    @IBOutlet weak var followChangeButton: UIButton!
    
    var changeName:String!
    var changeDetail:String!
    var changeID:String!
    var owner:String!
    var currentChange:Change!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Result"
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        nameField.enabled = false
        detailsField.selectable = false
        
        nameField.layer.masksToBounds = false
        nameField.layer.borderColor = UIColor.clearColor().CGColor
        nameField.layer.shadowRadius = 0.5
        nameField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        nameField.layer.shadowOffset = CGSizeMake(0,-1.0)
        nameField.layer.shadowOpacity = 0.5
        
        detailsField.layer.masksToBounds = false
        detailsField.layer.borderColor = UIColor.clearColor().CGColor
        detailsField.layer.shadowRadius = 0.5
        detailsField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        detailsField.layer.shadowOffset = CGSizeMake(0,-1.0)
        detailsField.layer.shadowOpacity = 0.5
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //clear out temp arrays ready for new result to be viewed:
        /*
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionVoteArray = []
        TempChange.sharedInstance().solutionIDArray = []
        */
        
        
        //load passed data into Temp variables to hold for use
        TempChange.sharedInstance().changeName = changeName
        TempChange.sharedInstance().changeOwner = owner
        TempChange.sharedInstance().changeDetail = changeDetail
        
        
        //set local fields to basic details
        self.nameField.text = changeName
        self.detailsField.textColor = UIColor.blackColor()
        self.detailsField.text = changeDetail
        
        _ = RetrieveSolutionsFromFirebase(changeID:changeID,/*change:currentChange,*/caller:"results"){
            (result) in
            
            /*
            for solution in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //put results from firebase into TempChange solutionArray 
                TempChange.sharedInstance().solutionIDArray.addObject(solution.key)
                TempChange.sharedInstance().solutionNameArray.addObject(solution.value["SolutionName"]!!)
                TempChange.sharedInstance().solutionDetailArray.addObject(solution.value["SolutionDescription"]!!)
                TempChange.sharedInstance().solutionVoteArray.addObject(solution.value["SolutionVoteCount"]!! as! Int)
                TempChange.sharedInstance().solutionOwnerArray.addObject(solution.value["SolutionOwner"]!! as! String)
                
            }
             */
            self.solutionTable.reloadData()
            
        }
        
    }
    
    @IBAction func followChangeClick(sender: UIButton) {
        
        
        _ = SaveResultToCoreData(changeID:self.changeID){
            (result) in
            
            
            self.currentChange = result as! Change
            
            //segue to Viewfollowed change VC
            var controller:ViewFollowingChangeViewController
            
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewFollowingChangeViewController") as! ViewFollowingChangeViewController
            
            controller.changeClicked = self.currentChange
            controller.sendingController = "ViewResult"
            
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        
        
        
        //TODO: need to add activity indicator to storyboard
        
        
        
    }
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempChange.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] 
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
                
        var controller:ViewIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewIdeaViewController") as! ViewIdeaViewController
        
        controller.viewControllerStatus = "results"
        controller.petitionURL = TempChange.sharedInstance().petitionURLArray[indexPath.row]
        controller.loadedNameData = TempChange.sharedInstance().solutionNameArray[indexPath.row]
        controller.loadedDetailData = TempChange.sharedInstance().solutionDetailArray[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
}
