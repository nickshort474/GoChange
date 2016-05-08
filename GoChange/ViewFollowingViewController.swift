//
//  ViewFollowingViewController.swift
//  GoChange
//
//  Created by Nick Short on 29/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase



class ViewFollowingViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var solutionTable: UITableView!
    @IBOutlet weak var addASolutionButton: UIButton!
    @IBOutlet weak var unfollowProblemButton: UIButton!
    
    var problemClicked:Problem!
    var problemID:String!
    var solutionID:String!
    var localSolutionCount:Int!
    var problemIDArray:[String] = []
    var sendingController:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //deal with scrollview issue
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        nameField.enabled = false
        detailsField.selectable = false
        
        self.title = "Following"
        
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
        
                
        
        //Set up drop shadow for detailsField
        solutionTable.layer.borderColor = UIColor.clearColor().CGColor
        solutionTable.layer.shadowRadius = 0.5
        solutionTable.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        solutionTable.layer.shadowOffset = CGSizeMake(0,-1.0)
        solutionTable.layer.shadowOpacity = 0.5
        
        
        //if coming from ViewResultViewController need back button to go home
        if(sendingController == "ViewResult"){
            
            let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewFollowingViewController.goBackHome))
            self.navigationItem.leftBarButtonItem = barButtonItem
            
        }
       
        nameField.text = problemClicked.problemName
        detailsField.text = problemClicked.problemDescription
        localSolutionCount = problemClicked.solutionCount as Int
        problemID = problemClicked.problemID
        
        //add problemID to problemID array ready for passing to RetrieveSolutions
        problemIDArray.append(problemID)
        
        
        //check to see whether solution count in database matches that in core data
        //Even if coming from results can check to see whether any new solutions added since search was conducted
        _ = RetrieveSolutionCountFirebase(problemArray: problemIDArray, completionHandler: {
            (result) in
            
            //process returned snapshot
            let firebaseSolutionCount = Int(result[0])
            
            // if new solutions exist
            if (firebaseSolutionCount != self.localSolutionCount){
                
                //retrieve from firebase
                _ = RetrieveSolutionsFromFirebase(problemID: self.problemID,problem:self.problemClicked,caller:"following", completionHandler: {
                    (result) in
                    
                   self.solutionTable.reloadData()
                    
                })
            }else{
                
                //No new solutions to download so gather existing ones from core data
                _ = RetrieveSolutions(problem:self.problemClicked!){
                    (result) in
                  
                    self.solutionTable.reloadData()
                    
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.solutionTable.reloadData()
        
    }
    
    
    @IBAction func addSolutionClick(sender: UIButton) {
        
        //if adding a new solution set back button title to cancel
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "addingSolutionToExistingProblem"
        //controller.problemID = problemID
        controller.problem = problemClicked
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TempSave.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        solutionName = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        let voteCount:String = String(TempSave.sharedInstance().solutionVoteArray[indexPath.row])
        
        cell.detailTextLabel!.text = "\(voteCount) votes"
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        var controller:ViewIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewIdeaViewController") as! ViewIdeaViewController
        
        controller.loadedNameData = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        controller.loadedDetailData = TempSave.sharedInstance().solutionDetailArray[indexPath.row]
        controller.solutionID = TempSave.sharedInstance().solutionIDArray[indexPath.row]
        controller.petitionURL = TempSave.sharedInstance().petitionURLArray[indexPath.row]
        controller.viewControllerStatus = "following"
        controller.problemID = problemID
        controller.index = indexPath.row
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func goBackHome(){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    
    @IBAction func unfollowProblem(sender: UIButton) {
        
        print("Problem unfollowed")
        _ = DeleteProblemFromCoreData(problem: problemClicked)
        
        //self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}