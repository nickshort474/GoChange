//
//  CreateChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData


class CreateChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var namePlusButton: UIButton!
    @IBOutlet weak var detailsPlusButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var solutionTable: UITableView!
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    var sendingController:String = ""
    var isOwner:String = ""
    var changeID = ""
    
    
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
       
        
        //TODO: If coming from FollowingViewController load core data details
        if(sendingController == "following"){
            // load core data 
            if(isOwner == "yes"){
                // allow edit buttons for name and details
                var retrievedChange = RetrieveChange(changeID: changeID){
                    (result) in
                    print(result)
                    
                }
                
            }
            
            
        }else if(sendingController == "results"){
            //TODO: load data from firebase
            
            //TODO: change POST button to SAVE/FOLLOW change
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
        
        //TODO: If viewing change load from core data 
        
        
        return TempChange.sharedInstance().solutionNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        
        let solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row]
        
        cell.textLabel!.text = solutionName as? String
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        
        
        
       
    }

    
    
        
    //---------------------Posting/Saving data----------------
    @IBAction func PostInfo(sender: UIButton) {
        
        //TODO: if button == POST save changes to core data and firebase
        let owner = true
        
        
        // else if button == SAVE/FOLLOW save changes to core data only
        // let owner = false
        
        
        if (currentDetailData == "" || currentNameData == ""){
            
            //TODO: message to user to get them to fill in form
            print("please input name and detail data")
            
        }else{
           
            var postDictionary:Dictionary = [String:AnyObject]()
            
            var newPost = PostData(postDictionary:postDictionary)
            
            
            /*
            // Create new change in CoreData and firebase
           let newChange = CreateChange(currentDetailData:currentDetailData,currentNameData:
                currentNameData,owner:owner)
            
            //TODO: retrieve firebase unique ID from core data and use it to set solution in both core data and firebase
            let request = NSFetchRequest()
            
            let entity = NSEntityDescription.entityForName("Change", inManagedObjectContext: sharedContext)
            let predicate = NSPredicate(format: "changeName == %@", currentNameData)
            
            request.entity = entity
            request.predicate = predicate
            
            
            
            do{
               let results =  try sharedContext.executeFetchRequest(request) as! [Change]
               
               if let entity = results.first{
                
                
                    let firebaseLocation = entity.firebaseLocation
                
                    for var i in 0 ..< (TempChange.sharedInstance().solutionNameArray.count){
                        _ = CreateSolution(change:newChange, firebaseLocation:firebaseLocation,solutionName:TempChange.sharedInstance().solutionNameArray[i] as! String,solutionDescription:TempChange.sharedInstance().solutionDetailArray[i] as! String)
                    }
                
                    /*
                    for (key,value) in TempChange.sharedInstance().solutionDictionary{
                        
                        _ = CreateSolution(firebaseLocation:firebaseLocation,solutionName: key, solutionDescription: value as! String)
                    }
                    */
                }
                
            }catch{
                //TODO: catch errors
            }
            */
                        
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
        
    }
    
    
}


