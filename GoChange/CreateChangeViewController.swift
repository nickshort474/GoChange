//
//  CreateChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class CreateChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var namePlusButton: UIButton!
    @IBOutlet weak var detailsPlusButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var addASolutionButton: UIButton!
    
    @IBOutlet weak var solutionTable: UITableView!
    
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    var sendingController:String = ""
    var isOwner:String = ""
    
    var changeName:String = ""
    var changeDetail:String = ""
    var changeID:String = ""
    
    var change:Change?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        //hide and disable buttons
        namePlusButton.hidden = true
        detailsPlusButton.hidden = true
        
        postButton.alpha = 0.5
        postButton.enabled = false
        
        //clear TempChange ready for new change
        TempChange.sharedInstance().changeName = ""
        TempChange.sharedInstance().changeDetail = ""
       
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionVoteArray = []
        TempChange.sharedInstance().solutionIDArray = []
        
        //TempChange.sharedInstance().tweakDetailArray = []
        //TempChange.sharedInstance().tweakNameArray = []
        
        
        // if coming from home VC hide follow button
        //self.followButton.hidden = true
        
        /*
        // If coming from FollowingViewController load core data details
        if(sendingController == "following"){
            
            //change title of VC to View Change
            self.title = "Followed Change"
            
            //if coming from following hide follow button
            self.followButton.hidden = true
            
            var localSolutionCount:Int?
            
            // load core data changes
            _ = RetrieveChange(changeID: changeID){
                (result) in
                
                self.change = result as? Change
                localSolutionCount = self.change?.solutionCount as? Int
                
                self.nameField.text = self.change!.changeName
                self.detailsField.textColor = UIColor.blackColor()
                self.detailsField.text = self.change!.changeDescription
                    
            }
            
            //connect to firebase and check solution count for change
           
            _ = RetrieveSolutionCountFirebase(changeID: changeID, completionHandler: {
                (result) in
                
                let firebaseSolutionCount = result.value as! Int
                
                 // compare to core data solution count and load extra solutions into core data if need be
                 if (firebaseSolutionCount != localSolutionCount){
                    
                    _ = RetrieveSolutionsFromFirebase(changeID: self.changeID, completionHandler: {
                        (result) in
                        
                        for name in result.children.allObjects as! [FDataSnapshot]{
                            
                            //assign results from firebase to Temp solutionArrays
                            TempChange.sharedInstance().solutionNameArray.addObject(name.value["SolutionName"]!!)
                            TempChange.sharedInstance().solutionDetailArray.addObject(name.value["SolutionDescription"]!!)
                            TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                        }
                        
                        //save the new set of solutions to core data
                        let postType:String = "updateCoreDataSolutions"
                        let owner:String = "true"
                        
                        _ = SaveData(postType:postType,owner:owner,change:self.change!)
                        
                        self.solutionTable.reloadData()
                        
                    })
                }else{
                    //load core data solutions
                    _ = RetrieveSolutions(change:self.change!){
                        (result) in
                        
                        //assign results from coreData return to temp array then use TempArray for table
                        let solutionArray = result as! [Solution]
                       
                        for solution in solutionArray{
         
                            TempChange.sharedInstance().solutionNameArray.addObject(solution.solutionName)
                            TempChange.sharedInstance().solutionDetailArray.addObject(solution.solutionDescription)
                            TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                        }
                        self.solutionTable.reloadData()
                
                    }
                }
            })
            
            
        }else if(sendingController == "results"){
            
            self.title = "Change Result"
            
            // if coming from results unhide follow button
            self.followButton.hidden = false
            
            
            self.nameField.text = changeName
            self.detailsField.textColor = UIColor.blackColor()
            self.detailsField.text = changeDetail
            
            // assign returned results to TempArray ready for later use
            TempChange.sharedInstance().changeName = changeName
            TempChange.sharedInstance().changeDetail = changeDetail
            
            
            //load data from firebase
            _ = RetrieveSolutionsFromFirebase(changeID:changeID){
                (snapshot) in
                
                for name in snapshot.children.allObjects as! [FDataSnapshot]{
                    
                    //put results from firebase into TempChange solutionArray
                    TempChange.sharedInstance().solutionNameArray.addObject(name.value["SolutionName"]!!)
                    TempChange.sharedInstance().solutionDetailArray.addObject(name.value["SolutionDescription"]!!)
                    TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                }
                self.solutionTable.reloadData()
                
            }
        }
         */
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.solutionTable.reloadData()
        
        /*
        //coming from following
        if(sendingController == "following" && TempChange.sharedInstance().addingSolutions != "true"){
            
            self.postButton.hidden = true
            self.followButton.hidden = true
            
        }
        
        //coming from follwoing and have added additional solution
        else if(sendingController == "following" && TempChange.sharedInstance().addingSolutions == "true"){
            
            self.postButton.hidden = false
            self.postButton.enabled = true
            self.postButton.alpha = 1
        }
        
        // coming from results
        else if(sendingController == "results"){
            
            //hide add a solution button
            self.addASolutionButton.hidden = true
            self.followButton.hidden = false
            
            //use passed in changeID to check whether result already exists in core data
            _ = RetrieveChange(changeID:self.changeID,completionHandler: {
                (result) in
                
         
                
                // if result exists in core data completionHandler will return
                
                //set follow button to unfollow? or following?
                self.followButton.hidden = true
                
                
            })
            
            
            
        }else{
           // coming from Home VC
        }
        
        //reload table data when coming back from solution/tweak
        self.solutionTable.reloadData()
        */
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    //-------------------Button methods---------------
    @IBAction func homeButtonClick(sender: UIButton) {
        /*
        if (sendingController == "following" || sendingController == "results"){
            navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        */
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func nameActionButton(sender: UIButton) {
        
        nameField.resignFirstResponder()
        namePlusButton.hidden = true
        
        if(nameField.text != "" && (detailsField.text != "" || detailsField.text != GoChangeClient.Constants.detailText)){
            postButton.alpha = 1
            postButton.enabled = true

        }
        
        currentNameData = nameField.text!
        TempChange.sharedInstance().changeName = nameField.text!
        
    }
    
    
    @IBAction func detailsActionButton(sender: UIButton) {
        
        //TODO: check for /n character, delete if necessary
        
        detailsField.resignFirstResponder()
        detailsPlusButton.hidden = true
        
        if(nameField.text != "" && (detailsField.text != "" || detailsField.text != GoChangeClient.Constants.detailText)){
            postButton.alpha = 1
            postButton.enabled = true
            
        }
        currentDetailData = detailsField.text!
        TempChange.sharedInstance().changeDetail = detailsField.text!
    }
    
    
    
    
    @IBAction func addSolution(sender: UIButton) {
        
        //if adding a new solution set back button title to cancel
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "adding"
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    
    //-----------------textfield methods-------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //TODO: If field begin editing due to user clicking instead of plus button save data?
        //TODO: Disable editing of fields until other field plus button clicked?
        
        namePlusButton.hidden = false
        detailsPlusButton.hidden = true
    }
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(textView.text == GoChangeClient.Constants.detailText){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        
        detailsPlusButton.hidden = false
        namePlusButton.hidden = true
        
    }
    
    
    
    
    
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
        let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "viewing"
        controller.loadedNameData = TempChange.sharedInstance().solutionNameArray[indexPath.row] as? String
        controller.loadedDetailData = TempChange.sharedInstance().solutionDetailArray[indexPath.row] as? String
        
        self.navigationController?.pushViewController(controller, animated: false)
        
    }

    
    
        
    //---------------------Posting/Saving data----------------
    @IBAction func PostInfo(sender: UIButton) {
        /*
        // if coming from following
        if(sendingController == "following"){
            
            //loop through solutionNewOldArray to check for newly added solutions
            for var i in 0 ..<  TempChange.sharedInstance().solutionNewOldArray.count{
            
                if(TempChange.sharedInstance().solutionNewOldArray[i] as! String == "new"){
                
                    // add newly added solutions to newSolution arrays
                    TempChange.sharedInstance().newSolutionNameArray.addObject(TempChange.sharedInstance().solutionNameArray[i])
                    TempChange.sharedInstance().newSolutionDetailArray.addObject(TempChange.sharedInstance().solutionDetailArray[i])
                
                }
            }
            
            // then run postData with postType
            let postType:String = "coreDataFirebaseSolutionPost"
            let owner:String = self.isOwner
            let change:Change = self.change!
            
            _ = SaveData(postType:postType,owner:owner,change:change)
            
        }else{
            // if coming from homeViewController ...
            // add everything to core data and firebase
            if(currentDetailData == "" || currentNameData == ""){
            
                //message to user to get them to fill in form
         
            
            }else{
           
                let postType:String = "fullPost"
                let owner:String = "true"
            
                _ = SaveData(postType:postType,owner:owner)
            
                self.dismissViewControllerAnimated(true, completion: nil)
            
            }
        }
         */
        
        
        //TODO: Check size of string? Stop people posting short questions?
        //TODO: Check for unusable data? USe GoChangeConvenieince for string testing
        if(currentDetailData == "" || currentNameData == ""){
            
            //TODO: Alert message to user to get them to fill in form
            print("please input name and detail data")
            
        }else{
            
            /*
            let postType:String = "fullPost"
            let owner:String = "true"
             = SaveData(postType:postType,owner:owner){
                (result) in
                //TODO: do i nedd result here? (change object) 
            }
            */
            _ = SaveNewChange(completionHandler:{
                (result) in
                
                //result is the newly created change!
                
            })
            
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }

        
    }
    
    
    /*
    @IBAction func followChange(sender: UIButton) {
        
        // if coming from results, add everything to core data
        
        let postType:String = "fullResultPost"
        let owner:String = "false"
        let changeID:String = self.changeID
        
        _ = SaveData(postType:postType,owner:owner,changeID:changeID)
        
        //refresh page with buttons re/dis enabled
        self.followButton.hidden = true
        
        self.addASolutionButton.hidden = false
        self.title = "following"
        self.sendingController = "following"
    
    }
    */
}


