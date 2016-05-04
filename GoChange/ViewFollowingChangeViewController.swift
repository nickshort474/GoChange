//
//  ViewFollowingChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 29/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase



class ViewFollowingChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var solutionTable: UITableView!
    @IBOutlet weak var addASolutionButton: UIButton!
    @IBOutlet weak var followChangeButton: UIButton!
    
    var changeClicked:Change!
    var changeID:String!
    var solutionID:String!
    var localSolutionCount:Int!
    var changeIDArray:[String] = []
    var sendingController:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        nameField.enabled = false
        detailsField.selectable = false
        
        self.title = "Following"
        
        detailsField.layer.masksToBounds = false
        detailsField.layer.shadowRadius = 0.5
        detailsField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        detailsField.layer.shadowOffset = CGSizeMake(0,-1.0)
        detailsField.layer.shadowOpacity = 0.5
        
        solutionTable.layer.masksToBounds = false
        solutionTable.layer.shadowRadius = 0.5
        solutionTable.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        solutionTable.layer.shadowOffset = CGSizeMake(0,-1.0)
        solutionTable.layer.shadowOpacity = 0.5
        
        
        //if coming from ViewResultChangeViewController need back button to go home
        if(sendingController == "ViewResult"){
            
            let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewFollowingChangeViewController.goBackHome))
            self.navigationItem.leftBarButtonItem = barButtonItem
            
        }
       
        nameField.text = changeClicked.changeName
        detailsField.text = changeClicked.changeDescription
        localSolutionCount = changeClicked.solutionCount as Int
        changeID = changeClicked.changeID
        
        //add changeID to changeID array ready for passing to RetrieveSolutions
        changeIDArray.append(changeID)
        
        
        //check to see whether solution count in database matches that in core data
        //Even if coming from results can check to see whether any new solutions added since search was conducted
        _ = RetrieveSolutionCountFirebase(changeArray: changeIDArray, completionHandler: {
            (result) in
            
            //process returned snapshot
            let firebaseSolutionCount = Int(result[0])
            
            // if new solutions exist
            if (firebaseSolutionCount != self.localSolutionCount){
                
                //retrieve from firebase
                _ = RetrieveSolutionsFromFirebase(changeID: self.changeID,change:self.changeClicked,caller:"following", completionHandler: {
                    (result) in
                    
                   self.solutionTable.reloadData()
                    
                })
            }else{
                
                //No new solutions to download so gather existing ones from core data
                _ = RetrieveSolutions(change:self.changeClicked!){
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
        
        controller.viewControllerStatus = "addingSolutionToExistingChange"
        //controller.changeID = changeID
        controller.change = changeClicked
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
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
        let voteCount:String = String(TempChange.sharedInstance().solutionVoteArray[indexPath.row])
        
        cell.detailTextLabel!.text = voteCount
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        var controller:ViewIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewIdeaViewController") as! ViewIdeaViewController
        
        controller.loadedNameData = TempChange.sharedInstance().solutionNameArray[indexPath.row]
        controller.loadedDetailData = TempChange.sharedInstance().solutionDetailArray[indexPath.row]
        controller.solutionID = TempChange.sharedInstance().solutionIDArray[indexPath.row]
        controller.petitionURL = TempChange.sharedInstance().petitionURLArray[indexPath.row]
        controller.viewControllerStatus = "following"
        controller.changeID = changeID
        controller.index = indexPath.row
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func goBackHome(){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func unfollowChange(sender: UIButton) {
        
        print("Change unfollowed")
        
    }
    
}