//
//  CreateProblemViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class CreateProblemViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var namePlusButton: UIButton!
    @IBOutlet weak var detailsPlusButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var addASolutionButton: UIButton!
    @IBOutlet weak var solutionTable: UITableView!
    
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.barTintColor = GoChangeClient.Constants.customOrangeColor
        
        addASolutionButton.setTitleColor(GoChangeClient.Constants.customOrangeColor, forState: UIControlState.Normal)
        
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        
        //set drop shadow for namefield
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
        
        
        
        
        //hide and disable buttons
        namePlusButton.hidden = true
        detailsPlusButton.hidden = true
        
        postButton.alpha = 0.5
        postButton.enabled = false
        
        //clear TempSave ready for new problem
        TempSave.sharedInstance().problemName = ""
        TempSave.sharedInstance().problemDetail = ""
       
        TempSave.sharedInstance().solutionDetailArray = []
        TempSave.sharedInstance().solutionNameArray = []
        TempSave.sharedInstance().solutionVoteArray = []
        TempSave.sharedInstance().solutionIDArray = []
        TempSave.sharedInstance().currentPetitionValue = ""
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.solutionTable.reloadData()
        
    }
    
    //get reference to managed object context
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    //-------------------Button methods---------------
    
    @IBAction func homeButtonClick(sender: UIButton) {
        
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
        TempSave.sharedInstance().problemName = nameField.text!
        detailsField.selectable = true
        detailsField.editable = true
    }
    
    
    @IBAction func detailsActionButton(sender: UIButton) {
        
        detailsField.resignFirstResponder()
        detailsPlusButton.hidden = true
        
        if(nameField.text != "" && (detailsField.text != "" || detailsField.text != GoChangeClient.Constants.detailText)){
            postButton.alpha = 1
            postButton.enabled = true
            
        }
        currentDetailData = detailsField.text!
        TempSave.sharedInstance().problemDetail = detailsField.text!
        nameField.enabled = true
    }
    
    
    
    
    @IBAction func addSolution(sender: UIButton) {
        
        //if adding a new solution set back button title to cancel
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "addingSolutionToNewProblem"
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    
    //-----------------textfield methods-------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        detailsField.selectable = false
        detailsField.editable = false
        
        namePlusButton.hidden = false
        detailsPlusButton.hidden = true
    }
    
    
    // set max length of name field to 40
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCount = textField.text?.characters.count ?? 0
        
        if(range.length + range.location > currentCount){
            return false
        }
        
        let newLength = currentCount + string.characters.count - range.length
        return newLength <= 40
    }
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
       
        if(textView.text == GoChangeClient.Constants.detailText){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        
        nameField.enabled = false
        
        detailsPlusButton.hidden = false
        namePlusButton.hidden = true
        
    }
    
    
    
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempSave.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CustomTableViewCell
        
        var solutionName:String = ""
        solutionName = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        
        
        cell.problemName.text = solutionName
        
        let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        
        if let username = username{
            cell.ownerName.text = "Submitted by: \(username)"
        }
        
        cell.voteCount.text = "0"
        
        cell.layer.masksToBounds = false
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        cell.layer.shadowOffset = CGSizeMake(3.0,3.0)
        cell.layer.shadowOpacity = 0.5
        
        return cell
        
    }
    
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //change back button on addIdeaVC to Back instead of "Cancel Idea"
        let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:ViewIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewIdeaViewController") as! ViewIdeaViewController
        
        controller.viewControllerStatus = "newProblem"
        controller.petitionURL = TempSave.sharedInstance().petitionURLArray[indexPath.row]
        controller.loadedNameData = TempSave.sharedInstance().solutionNameArray[indexPath.row]
        controller.loadedDetailData = TempSave.sharedInstance().solutionDetailArray[indexPath.row]
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    
    
        
    //---------------------Posting/Saving data----------------
    @IBAction func PostInfo(sender: UIButton) {
        
        // if text fields empty present alert
        if(currentDetailData == "" || currentNameData == ""){
            
            self.presentAlert("Please input both name and detail data")
            
        }else{
           
            //test for network connection before proceeding
            _ = CheckForNetwork(){
                (result) in
               
                if(result == "Connected"){
                    
                    //save problem
                    _ = SaveNewProblem(completionHandler:{
                        (result) in
                        
                        // deal with if problem name already exists
                       if(result as! String == "exists"){
                            self.presentAlert("Problem name already exists in database, please try another name")
                        }else{
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    })
                    
                }else{
                    
                    // if no network present alert
                    self.presentAlert("Cannot post problem, please check your network and try again")
                }
            }
 
        }
    }
    
    
    //present alerts
    func presentAlert(alertType:String){
        
        let controller = UIAlertController()
        controller.message = alertType
        
        let alertAction = UIAlertAction(title: "Please try again", style: UIAlertActionStyle.Cancel){
            action in
            
        }
        
        controller.addAction(alertAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}


