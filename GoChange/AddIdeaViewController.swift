//
//  AddIdeaViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class AddIdeaViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UITableViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addDetailButton: UIButton!
    @IBOutlet weak var addSolution: UIButton!
    @IBOutlet weak var petitionButton: UIButton!
    @IBOutlet weak var petitionTextField: UITextField!
    
    var currentNameData:String!
    var currentDetailData:String!
    var viewControllerStatus:String!
    var problem:Problem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set nav title
        self.navigationController?.title = "Add Solution"
        
        //set state of ui elements
        addNameButton.hidden = true
        addDetailButton.hidden = true
        addSolution.enabled = false
        addSolution.alpha = 0.5
        
        //petitionTextField.enabled = false
 
        //set delegates
        nameTextField.delegate = self
        detailTextView.delegate = self

        //clear current petition value after previous use
        TempSave.sharedInstance().currentPetitionValue = ""
        
        
        // style name and detail fields
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowRadius = 0.5
        nameTextField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        nameTextField.layer.shadowOffset = CGSizeMake(1.0,1.0)
        nameTextField.layer.shadowOpacity = 0.5
        nameTextField.borderStyle = UITextBorderStyle.None
        
        detailTextView.layer.masksToBounds = false
        detailTextView.layer.borderColor = UIColor.clearColor().CGColor
        detailTextView.layer.shadowRadius = 0.5
        detailTextView.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        detailTextView.layer.shadowOffset = CGSizeMake(1.0,1.0)
        detailTextView.layer.shadowOpacity = 0.5
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
       //clear newSolutionArrays ready for new input
        TempSave.sharedInstance().newSolutionNameArray = []
        TempSave.sharedInstance().newSolutionDetailArray = []
        
        //set petition field text
        petitionTextField.text = TempSave.sharedInstance().currentPetitionValue
        
    }
    
   
    
    @IBAction func doneAddingIdea(sender: UIButton) {
        
        
        if(viewControllerStatus == "addingSolutionToExistingProblem"){
            
            if(nameTextField.text != "" && detailTextView.text != ""){
            
                
                //Add data to existing arrays ready for going back to ViewFollowing
                TempSave.sharedInstance().solutionNameArray.append(nameTextField.text!)
                TempSave.sharedInstance().solutionDetailArray.append(detailTextView.text!)
                TempSave.sharedInstance().solutionVoteArray.append(0)
                TempSave.sharedInstance().solutionIDArray.append("newSolution")
                
                //get solutionOwner
                let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
                
                //save solution owner
                TempSave.sharedInstance().solutionOwnerArray.append(solutionOwner)
                
                
                //Save data to newSolutionArrays ready for posting of SaveNewSoltion
                TempSave.sharedInstance().newSolutionNameArray.append(nameTextField.text!)
                TempSave.sharedInstance().newSolutionDetailArray.append(detailTextView.text!)
                
                
                
                if(petitionTextField.text != GoChangeClient.Constants.basePetitionURL){
                    
                    // if user has navigated to a petition rather than just the homepage
                    TempSave.sharedInstance().petitionURLArray.append(petitionTextField.text!)
                    TempSave.sharedInstance().newPetitionURLArray.append(petitionTextField.text!)
                    
                }else{
                    
                    //If haven't gone past homepage or not added petition
                    TempSave.sharedInstance().petitionURLArray.append("")
                    TempSave.sharedInstance().newPetitionURLArray.append("")
                    
                }
                
                //save the solution
                _ = SaveNewSolution(problem: self.problem){
                    (result) in
                    
                }
                
                // dismiss view controller from navigation stack
                self.navigationController?.popViewControllerAnimated(true)
                
                
            }
        }else if(viewControllerStatus == "addingSolutionToNewProblem"){
            
            if(nameTextField.text != "" && detailTextView.text != ""){
                
                TempSave.sharedInstance().solutionNameArray.append(nameTextField.text!)
                TempSave.sharedInstance().solutionDetailArray.append(detailTextView.text!)
                TempSave.sharedInstance().solutionVoteArray.append(0)
                TempSave.sharedInstance().solutionIDArray.append("newSolution")
                                
                if(petitionTextField.text != GoChangeClient.Constants.basePetitionURL){
                    
                    // if user has navigated to a petition rather than just the homepage
                    TempSave.sharedInstance().petitionURLArray.append(petitionTextField.text!)
                    
                }else{
                    
                    //If haven't gone past homepage or not added petition
                    TempSave.sharedInstance().petitionURLArray.append("")
                    
                }
                
                
                self.navigationController?.popViewControllerAnimated(true)
                
            }
        }
        
    }
    
    
    
    //save the data from name field into a var, alter UI accordingly
    @IBAction func addNameClick(sender: AnyObject) {
        
        nameTextField.resignFirstResponder()
        addNameButton.hidden = true
        currentNameData = nameTextField.text
        
        if(nameTextField.text != "" && detailTextView.text != ""){
            addSolution.enabled = true
            addSolution.alpha = 1
        }
        
        detailTextView.selectable = true
        detailTextView.editable = true
    }
    
    
    //save the data from detail View into a var, alter UI accordingly
    @IBAction func addDetailClick(sender: UIButton) {
        
        detailTextView.resignFirstResponder()
        addDetailButton.hidden = true
        currentDetailData = detailTextView.text
        
        if(nameTextField.text != "" && detailTextView.text != ""){
            addSolution.enabled = true
            addSolution.alpha = 1
        }
        
        nameTextField.enabled = true
    }
    
    
    
    //-------------textfield methods ---------------
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addNameButton.hidden = false
        detailTextView.selectable = false
        detailTextView.editable = false
    }
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(textView.text == "Please enter details of the solution you have..."){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        addDetailButton.hidden = false
        addNameButton.hidden = true
        
        nameTextField.enabled = false
    }
    
    
    
    
    //---------------petition methods--------------------
    
    @IBAction func addPetition(sender: UIButton) {
        
        //open web browser to go to change.org
        var controller:WebViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
       
        controller.urlString = GoChangeClient.Constants.basePetitionURL
        //controller.status = "adding"
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


