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
    @IBOutlet weak var solutionTable: UITableView!
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    var sendingController:String = ""
    var isOwner:String = ""
    var changeID = ""
    
    var retrievedSolutionArray = [Solution]()
    
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
            
           //TODO: change title of VC to View Change
            
           var change:Change?
            
            
            
            
            
            //TODO: check for ownership and then dis/allow edit buttons for name and details
            if isOwner == "true"{
                // allow editing
            }else{
                // disallow editing
            }
            
            
            
            
             // load core data
            _ = RetrieveChange(changeID: changeID){
                (result) in
                change = result as? Change
                print(change)
                    
                self.nameField.text = change!.changeName
                self.detailsField.textColor = UIColor.blackColor()
                self.detailsField.text = change!.changeDescription
                    
            }
            _ = RetrieveSolutions(change:change!){
                (result) in
                print(result)
                self.retrievedSolutionArray = result as! [Solution]
            }
          
            
            
            
        }else if(sendingController == "results"){
            //TODO: load data from firebase
            
            let dictionary = [String:AnyObject]()
            
            _ = RetrieveFromFirebase(){
                (snapshot) in
                
                //var nameArray:NSMutableArray = []
                //var refArray:NSMutableArray = []
                
                //for rest  in  results.children.allObjects as! [FDataSnapshot]{
                    //print(rest.value)
               // }
                //print(snapshot.ref)
                //print(snapshot.key)
                
                for name in snapshot.children.allObjects as! [FDataSnapshot]{
                    print(name.value["ChangeName"]!)
                    print(name.ref)
                }
               
                
                
            }
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
        if sendingController == "following"{
            
            return retrievedSolutionArray.count
            
        }else{
            return TempChange.sharedInstance().solutionNameArray.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        
        if sendingController == "following"{
            solutionName = retrievedSolutionArray[indexPath.row].solutionName
            
        }else{
            solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] as! String
        }
        
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
        
        //TODO: if button == POST save changes to core data and firebase
        _ = true
        
        
        // else if button == SAVE/FOLLOW save changes to core data only
        // let owner = false
        
        
        if (currentDetailData == "" || currentNameData == ""){
            
            //TODO: message to user to get them to fill in form
            print("please input name and detail data")
            
        }else{
           
            let postDictionary:Dictionary = [String:AnyObject]()
            
            
            
            _ = PostData(postDictionary:postDictionary)
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        
    }
    
    
}


