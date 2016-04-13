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
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var addASolutionButton: UIButton!
    
    
    
    @IBOutlet weak var solutionTable: UITableView!
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    var sendingController:String = ""
    var isOwner:String = ""
    
    var changeName:String = ""
    var changeDetail:String = ""
    var changeID:String = ""
    
    var retrievedSolutionArray = [Solution]()
    
    var change:Change?
    
    
    //var firebaseSolutionNames:NSMutableArray = []
    //var firebaseSolutionDetails:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //clear TempChange ready for new change
        TempChange.sharedInstance().changeName = ""
        TempChange.sharedInstance().changeDetail = ""
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().tweakDetailArray = []
        TempChange.sharedInstance().tweakNameArray = []
        
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        //hide and disable buttons
        namePlusButton.hidden = true
        detailsPlusButton.hidden = true
        postButton.alpha = 0.5
        postButton.enabled = false
        
        //set back button title
        let barButtonItem = UIBarButtonItem(title: "Cancel Idea", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
       
        self.followButton.hidden = true
        
        
        
        
        
        
        // If coming from FollowingViewController load core data details
        if(sendingController == "following"){
            
            //change title of VC to View Change
            self.title = "View Change"
            self.followButton.hidden = true
            
            //TODO: check for ownership and then dis/allow edit buttons for name and details
            if (isOwner == "true"){
                // allow editing
                
                
            }else{
                // disallow editing
                
                
                
            }
            
            
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
                
                 // compare to core data solution count and load extra solutions into core data
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
                        //print(result)
                        //self.retrievedSolutionArray = result as! [Solution]
                
                        //TODO: assign results from coreData return to temp array then use TempArray for table
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
            
            self.title = "View Change"
            self.followButton.hidden = false
            
            
            self.nameField.text = changeName
            self.detailsField.textColor = UIColor.blackColor()
            self.detailsField.text = changeDetail
            
            
            
            TempChange.sharedInstance().changeName = changeName
            TempChange.sharedInstance().changeDetail = changeDetail
            
            //changeDictionary[Change.Keys.firebaseLocation] = savedAutoID
            //changeDictionary[Change.Keys.changeID] = changeID
            //changeDictionary[Change.Keys.solutionCount] = TempChange.sharedInstance().solutionNameArray.count
            
            
            
            //TODO: load data from firebase
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
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        if(sendingController == "following" && TempChange.sharedInstance().addingSolutions != "true"){
            
            self.postButton.hidden = true
            self.followButton.hidden = true
            
        }else if(sendingController == "following" && TempChange.sharedInstance().addingSolutions == "true"){
            
            self.postButton.hidden = false
        }
        
        if(sendingController == "results"){
            self.addASolutionButton.hidden = true
            self.followButton.hidden = false
        }
        
        //reload table data when coming back from solution/tweak
        self.solutionTable.reloadData()
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    //-------------------Button methods---------------
    @IBAction func homeButtonClick(sender: UIButton) {
        
        if (sendingController == "following" || sendingController == "results"){
            navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func nameActionButton(sender: UIButton) {
        nameField.resignFirstResponder()
        
        namePlusButton.hidden = true
        
        if(nameField.text != "" && (detailsField.text != "" || detailsField.text != "Please enter details of the change you would like to see...")){
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
        
        if(nameField.text != "" && (detailsField.text != "" || detailsField.text != "Please enter details of the change you would like to see...")){
            postButton.alpha = 1
            postButton.enabled = true
            
        }
        currentDetailData = detailsField.text!
        TempChange.sharedInstance().changeDetail = detailsField.text!
    }
    
    
    
    
    @IBAction func addSolution(sender: UIButton) {
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    
    //-----------------textfield methods-------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        namePlusButton.hidden = false
        detailsPlusButton.hidden = true
    }
    
    
    
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(textView.text == "Please enter details of the change you would like to see..."){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        
        detailsPlusButton.hidden = false
        namePlusButton.hidden = true
        
        
    }
    
    
    
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return TempChange.sharedInstance().solutionNameArray.count
        /*
        if sendingController == "following"{
            
            return retrievedSolutionArray.count
            
        }else if(sendingController == "results"){
            
            return firebaseSolutionNames.count
            
        }else{
            
            return TempChange.sharedInstance().solutionNameArray.count
            
        }
        */
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] as! String
        
        /*
        if sendingController == "following"{
            solutionName = retrievedSolutionArray[indexPath.row].solutionName
        }else if(sendingController == "results"){
            solutionName = firebaseSolutionNames[indexPath.row] as! String
        }else{
            solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] as! String
        }
        */
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    
    
        
    //---------------------Posting/Saving data----------------
    @IBAction func PostInfo(sender: UIButton) {
        
        // if coming from following
        if(sendingController == "following"){
            
            // post solutions to firebase and add solutions to core data
        
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
            
                //TODO: message to user to get them to fill in form
                print("please input name and detail data")
            
            }else{
           
                let postType:String = "fullPost"
                let owner:String = "true"
            
                _ = SaveData(postType:postType,owner:owner)
            
                self.dismissViewControllerAnimated(true, completion: nil)
            
            }
        }
        
    }
    
    
    
    @IBAction func followChange(sender: UIButton) {
        
        // if coming from results, add everything to core data
        
        
        
        let postType:String = "fullResultPost"
        let owner:String = "false"
        //let change:Change = nil
        let changeID:String = self.changeID
        
        _ = SaveData(postType:postType,owner:owner,changeID:changeID)
        
        //TODO: refresh page with buttons re/dis enabled
        self.followButton.hidden = true
        
    }
    
}


