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
    var change:Change!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.title = "Add Solution"
        addNameButton.hidden = true
        addDetailButton.hidden = true
        
        addSolution.enabled = false
        addSolution.alpha = 0.5
        
        petitionTextField.text = ""
        petitionTextField.enabled = false
        
        nameTextField.delegate = self
        detailTextView.delegate = self
        
        
        detailTextView.layer.masksToBounds = false
        detailTextView.layer.borderColor = UIColor.clearColor().CGColor
        detailTextView.layer.shadowRadius = 0.5
        detailTextView.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        detailTextView.layer.shadowOffset = CGSizeMake(0,-1.0)
        detailTextView.layer.shadowOpacity = 0.5
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
       //clear newSolutionArrays ready for new input
        TempChange.sharedInstance().newSolutionNameArray = []
        TempChange.sharedInstance().newSolutionDetailArray = []
        
        petitionTextField.text = TempChange.sharedInstance().currentPetitionValue
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneAddingIdea(sender: UIButton) {
        
        if(viewControllerStatus == "addingSolutionToExistingChange"){
            
            if(nameTextField.text != "" && detailTextView.text != ""){
            
                
                //Add data to existing arrays ready for going back to ViewFollowing to display in table and for firebase solutionCount / SaveNewChange
                TempChange.sharedInstance().solutionNameArray.append(nameTextField.text!)
                TempChange.sharedInstance().solutionDetailArray.append(detailTextView.text!)
                TempChange.sharedInstance().solutionVoteArray.append(0)
                TempChange.sharedInstance().solutionIDArray.append("newSolution")
                
                //Save data to newSolutionArrays ready for posting of SaveNewSoltion
                TempChange.sharedInstance().newSolutionNameArray.append(nameTextField.text!)
                TempChange.sharedInstance().newSolutionDetailArray.append(detailTextView.text!)
                
                
                
                if(petitionTextField.text != GoChangeClient.Constants.basePetitionURL){
                    
                    // if user has navigated to a petition rather than just the homepage
                    TempChange.sharedInstance().petitionURLArray.append(petitionTextField.text!)
                    TempChange.sharedInstance().newPetitionURLArray.append(petitionTextField.text!)
                    
                }else{
                    
                    //If haven't gone past homepage or not added petition
                    TempChange.sharedInstance().petitionURLArray.append("")
                    TempChange.sharedInstance().newPetitionURLArray.append("")
                    
                }
                
                
                _ = SaveNewSolution(change: self.change){
                    (result) in
                    
                }
                
                // dismiss view controller from navigation stack
                self.navigationController?.popViewControllerAnimated(true)
            }
        }else if(viewControllerStatus == "addingSolutionToNewChange"){
            
            if(nameTextField.text != "" && detailTextView.text != ""){
                
                TempChange.sharedInstance().solutionNameArray.append(nameTextField.text!)
                TempChange.sharedInstance().solutionDetailArray.append(detailTextView.text!)
                TempChange.sharedInstance().solutionVoteArray.append(0)
                TempChange.sharedInstance().solutionIDArray.append("newSolution")
                                
                if(petitionTextField.text != GoChangeClient.Constants.basePetitionURL){
                    
                    // if user has navigated to a petition rather than just the homepage
                    TempChange.sharedInstance().petitionURLArray.append(petitionTextField.text!)
                    
                }else{
                    
                    //If haven't gone past homepage or not added petition
                    TempChange.sharedInstance().petitionURLArray.append("")
                    
                }
                
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    
    
    
    @IBAction func addNameClick(sender: AnyObject) {
        
        nameTextField.resignFirstResponder()
        addNameButton.hidden = true
        currentNameData = nameTextField.text
        
        if(nameTextField.text != "" && detailTextView.text != ""){
            addSolution.enabled = true
            addSolution.alpha = 1
        }
        
    }
    
    @IBAction func addDetailClick(sender: UIButton) {
        
        detailTextView.resignFirstResponder()
        addDetailButton.hidden = true
        currentDetailData = detailTextView.text
        
        //TODO: add check for "placeholder" text
        if(nameTextField.text != "" && detailTextView.text != ""){
            addSolution.enabled = true
            addSolution.alpha = 1
        }
    }
    
    
    
    //-------------textfield methods ---------------
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addNameButton.hidden = false
    }
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(textView.text == "Please enter details of the solution you have..."){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        addDetailButton.hidden = false
        addNameButton.hidden = true
        
    }
    
    
    
    
    
    
    //---------------petition methods--------------------
    
    @IBAction func addPetition(sender: UIButton) {
        
        //open web browser to go to change.org
        
        var controller:WebViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
       
        
        
        controller.urlString = GoChangeClient.Constants.basePetitionURL
        controller.status = "adding"
        
        
        //print(GoChangeClient.Constants.basePetitionURL)
        
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
        
}


