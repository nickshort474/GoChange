//
//  ViewResultViewController.swift
//  GoChange
//
//  Created by Nick Short on 15/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class ViewResultViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var solutionTable: UITableView!
    @IBOutlet weak var followProblemButton: UIButton!
    
    var problemName:String!
    var problemDetail:String!
    var problemID:String!
    var owner:String!
    var currentProblem:Problem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Result"
        
        //deal with scrollview issue
        self.automaticallyAdjustsScrollViewInsets = false
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        nameField.enabled = false
        detailsField.selectable = false
        
        
        //drop shadow for nameField
        nameField.layer.masksToBounds = false
        nameField.borderStyle = UITextBorderStyle.None
        nameField.layer.shadowRadius = 0.5
        nameField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        nameField.layer.shadowOffset = CGSizeMake(1.0,1.0)
        nameField.layer.shadowOpacity = 0.5
        
        
        //Set up drop shadow for detailsField
        detailsField.layer.masksToBounds = false
        detailsField.layer.borderColor = UIColor.clearColor().CGColor
        detailsField.layer.shadowRadius = 0.5
        detailsField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        detailsField.layer.shadowOffset = CGSizeMake(1.0,1.0)
        detailsField.layer.shadowOpacity = 0.5
        
       
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //load passed data into Temp variables to hold for use
        TempSave.sharedInstance().problemName = problemName
        TempSave.sharedInstance().problemOwner = owner
        TempSave.sharedInstance().problemDetail = problemDetail
        
        
        //set local fields to basic details
        self.nameField.text = problemName
        self.detailsField.textColor = UIColor.blackColor()
        self.detailsField.text = problemDetail
        
        _ = RetrieveSolutionsFromFirebase(problemID:problemID,caller:"results"){
            (result) in
            
            self.solutionTable.reloadData()
            
        }
        
    }
    
    @IBAction func followProblemClick(sender: UIButton) {
        
        TempSave.sharedInstance().retrievedProblemFollowed = true
        TempSave.sharedInstance().RetrievedProblemsCount -= 1
        
        if(TempSave.sharedInstance().RetrievedProblemsCount == 0){
            TempSave.sharedInstance().RetrievedProblemsEmpty = true
        }
        
        _ = SaveResultToCoreData(problemID:self.problemID){
            (result) in
            
            
            self.currentProblem = result as! Problem
            
            //segue to ViewfollowedVC
            var controller:ViewFollowingViewController
            
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewFollowingViewController") as! ViewFollowingViewController
            
            controller.problemClicked = self.currentProblem
            controller.sendingController = "ViewResult"
            
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        
        
    }
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempSave.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CustomTableViewCell
        
        
         let solutionName = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        let owner = TempSave.sharedInstance().solutionOwnerArray[indexPath.row]
        
        let solutionVoteCount = String(TempSave.sharedInstance().solutionVoteArray[indexPath.row])
        
        
        cell.problemName.text = solutionName
        cell.ownerName.text = "By: \(owner)"
        cell.voteCount.text = solutionVoteCount
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
                
        var controller:ViewIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewIdeaViewController") as! ViewIdeaViewController
        
        controller.viewControllerStatus = "results"
        controller.petitionURL = TempSave.sharedInstance().petitionURLArray[indexPath.row]
        controller.loadedNameData = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        controller.loadedDetailData = TempSave.sharedInstance().solutionDetailArray[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
}
