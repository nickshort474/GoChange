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
    
    @IBOutlet weak var detailListViewDivider: UIImageView!
    @IBOutlet weak var nameDetailDivider: UIImageView!
    
    @IBOutlet weak var namePlusButton: UIButton!
    @IBOutlet weak var detailsPlusButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    var sendingController:String = ""
    var isOwner:String = ""
    
    
    @IBOutlet weak var solutionTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: If coming from FollowingViewController load core data details
        
        if(sendingController == "following"){
            // load core data 
            if(isOwner == "yes"){
                // allow edit buttons for name and details 
            }
            
            
        }else if(sendingController == "results"){
            //TODO: load data from firebase
            
            //TODO: change POST button to SAVE/FOLLOW change
        }
        
        // If owner of change allow editing buttons
        
        
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        namePlusButton.hidden = true
        detailsPlusButton.hidden = true
        postButton.alpha = 0.5
        postButton.enabled = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //-------------------Button methods---------------
    @IBAction func homeButtonClick(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func nameActionButton(sender: UIButton) {
        nameField.resignFirstResponder()
        currentNameData = nameField.text!
        namePlusButton.hidden = true
        
        if(nameField.text != "" && detailsField.text != ""){
            postButton.alpha = 1
            postButton.enabled = true

        }
        
    }
    
    
    @IBAction func detailsActionButton(sender: UIButton) {
        
        //TODO: check for /n character, delete if necessary
        
        detailsField.resignFirstResponder()
         currentDetailData = detailsField.text!
        detailsPlusButton.hidden = true
        
        if(nameField.text != "" && detailsField.text != ""){
            postButton.alpha = 1
            postButton.enabled = true
            
        }
        
    }
    
    
    //-----------------textfield methods-------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        namePlusButton.hidden = false
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
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        cell.textLabel!.text = "Add a solution"
        
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
        let owner = true
        
        
        // else if button == SAVE/FOLLOW save changes to core data only
        // let owner = false
        
        
        if (currentDetailData == "" || currentNameData == ""){
            
            //TODO: message to user to get them to fill in form
            print("please input name and detail data")
            
        }else{
            _ = CreateChange(currentDetailData:currentDetailData,currentNameData:
                currentNameData,owner:owner)
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
        
    }
    
    
}


