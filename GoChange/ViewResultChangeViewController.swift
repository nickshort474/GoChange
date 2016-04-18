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
    
    //@IBOutlet weak var nameButton: UIButton!
    //@IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var followChangeButton: UIButton!
    
    
    var isOwner:String!
    var changeName:String!
    var changeDetail:String!
    var changeID:String!
    
    var currentChange:Change!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Result"
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        
        //TODO: have prompt for user to follow change if they try clicking fields?
        
        
        //once followed then segue to followed VC with editing allowed???
        
        //let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: "goBackHome:", action: nil)
        //self.navigationItem.backBarButtonItem = barButtonItem
        
        //self.navigationItem.leftBarButtonItem = barButtonItem
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //clear out temp arrays ready for new result to be viewed:
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionNewOldArray = []
        
        
        
        //load passed data into Temp variables to hold for use
        TempChange.sharedInstance().changeName = changeName
        TempChange.sharedInstance().changeDetail = changeDetail
        
        
        //set local fields to basic details
        self.nameField.text = changeName
        self.detailsField.textColor = UIColor.blackColor()
        self.detailsField.text = changeDetail
        
        _ = RetrieveSolutionsFromFirebase(changeID:changeID){
            (snapshot) in
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //put results from firebase into TempChange solutionArray
                TempChange.sharedInstance().solutionNameArray.addObject(name.value["SolutionName"]!!)
                TempChange.sharedInstance().solutionDetailArray.addObject(name.value["SolutionDescription"]!!)
                
                //TODO:Check for use
                TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                
                
                
            }
            self.solutionTable.reloadData()
            
        }
        
    }
    
    /*
    @IBAction func addNameClick(sender: UIButton) {
        // if owner == true
        //enable button
        
        //
        
        
    }
    
    
    @IBAction func addDetailClick(sender: UIButton) {
        // if owner == true
        //enable button
    }
    */
    
    
    /*
    @IBAction func addSolutionClick(sender: UIButton) {
        
    }
    */
    
    @IBAction func followChangeClick(sender: UIButton) {
        
        
        //save details of currently viewed Change -- saved in TempArray
        let postType:String = "fullResultPost"
        let owner:String = "false"
        let changeID:String = self.changeID
        
        
        //TODO: add possible completion handler to return newly created change
        _ = SaveData(postType:postType,owner:owner,changeID:changeID){
            (result) in
            
            self.currentChange = result as! Change
            
        }
        
        
        
        //TODO: need to add activity indicator to storyboard
        
        //segue to Viewfollowed change VC
        var controller:ViewFollowedChangeViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewFollowedChangeViewController") as! ViewFollowedChangeViewController
        
        controller.changeClicked = self.currentChange
        controller.sendingController = "ViewResult"
        //self.presentViewController(controller, animated: false, completion: nil)
        
        
        self.navigationController?.pushViewController(controller, animated: false)
        
        //let navigationController = self.navigationController
        
        //navigationController?.pushViewController(controller,animated: true)
                
        //TODO: refresh page with buttons re/dis enabled
        //self.followButton.hidden = true
        
        //self.addASolutionButton.hidden = false
        //self.title = "following"
        //self.sendingController = "following"
        
        
        //controller.sendingController = "following"
        
        
        //controller.changeClicked = fetchedResultsController.objectAtIndexPath(indexPath) as! Change
        
        /*
         controller.isOwner = changeClicked.owner
         controller.changeID = changeClicked.changeID
         controller.changeName = changeClicked.changeName
         controller.changeDetail = changeClicked.changeDescription
         */
        
        
    }
    
    /*
    @IBAction func postChangeClick(sender: UIButton) {
        
    }
 
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        
        
    }
    
    
    */
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempChange.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] as! String
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //change back button on addIdeaVC to Back instead of "Cancel Idea"
        
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "viewing"
        controller.loadedNameData = TempChange.sharedInstance().solutionNameArray[indexPath.row] as? String
        controller.loadedDetailData = TempChange.sharedInstance().solutionDetailArray[indexPath.row] as? String
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func goBackHome(){
        
    }
    
    
}
