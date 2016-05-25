//
//  ViewIdeaViewController.swift
//  GoChange
//
//  Created by Nick Short on 28/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class ViewIdeaViewController:UIViewController{
    
    
    @IBOutlet weak var solutionNameField: UITextField!
    @IBOutlet weak var solutionDetailField: UITextView!
    @IBOutlet weak var viewPetitionButton: UIButton!
    @IBOutlet weak var voteSolutionButton: UIButton!
    @IBOutlet weak var petitionTextField: UITextField!
    @IBOutlet weak var secondPetitionTextField: UITextField!
    @IBOutlet weak var petitionActivity: UIActivityIndicatorView!
    
    
    var problemID:String!
    var solutionID:String!
    var viewControllerStatus:String!
    var loadedNameData:String!
    var loadedDetailData:String!
    var petitionURL:String!
    var index:Int!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        petitionActivity.stopAnimating()
        petitionActivity.hidden = true
        
        //deal with scrollview issue
        self.automaticallyAdjustsScrollViewInsets = false
        
        //disable text editing
        solutionNameField.enabled = false
        solutionDetailField.selectable = false
        petitionTextField.enabled = false
        
        
        //setup drop shadow for namefield
        solutionNameField.layer.masksToBounds = false
        solutionNameField.borderStyle = UITextBorderStyle.None
        solutionNameField.layer.shadowRadius = 0.5
        solutionNameField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        solutionNameField.layer.shadowOffset = CGSizeMake(1.0,1.0)
        solutionNameField.layer.shadowOpacity = 0.5
        
        
        //Set up drop shadow for detailsField
        solutionDetailField.layer.masksToBounds = false
        solutionDetailField.layer.borderColor = UIColor.clearColor().CGColor
        solutionDetailField.layer.shadowRadius = 0.5
        solutionDetailField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        solutionDetailField.layer.shadowOffset = CGSizeMake(1.0,1.0)
        solutionDetailField.layer.shadowOpacity = 0.5
        
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //set text
        solutionNameField.text = loadedNameData
        solutionDetailField.textColor = UIColor.blackColor()
        solutionDetailField.text = loadedDetailData
    
        
        //hide vote button if new user created button or coming from results
        if(viewControllerStatus == "newProblem" || viewControllerStatus == "results"){
            
            voteSolutionButton.enabled = false
            voteSolutionButton.alpha = 0
            
        }else if(viewControllerStatus == "following"){
            
            //check whether haveVoted for and set buttons
            _ = CheckVote(solutionID:solutionID){
                result in
            
                let haveVoted = result.haveVotedFor
                
                if(haveVoted == "yes"){
                    self.voteSolutionButton.enabled = false
                    self.voteSolutionButton.alpha = 0
                }else{
                    
                    // if havent voted show button
                    self.voteSolutionButton.enabled = true
                    self.voteSolutionButton.alpha = 1
                }
            
            }
            
        }
       
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //if we have a petition URL
        if(petitionURL != ""){
            
            petitionActivity.startAnimating()
            petitionActivity.hidden = false
            view.alpha = 0.5
            viewPetitionButton.enabled = false
            
            //get petition data from change.org
            _ = ChangeOrgCode(petitionURL:petitionURL){
                result in
                
                //get signature count
                if let resultSignCount = result["signature_count"]{
                    
                    if let resultSignCount = resultSignCount{
                        
                        let petitionText = "Current Signature count is: \(String(resultSignCount))"
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.secondPetitionTextField.text = petitionText
                        })
                        
                    }
                    
                }
                
                //get tilte
                if let resultTitle = result["title"]{
                    if let resultTitle = resultTitle{
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.petitionTextField.text = resultTitle as? String
                            self.petitionActivity.stopAnimating()
                            self.petitionActivity.hidden = true
                            self.view.alpha = 1
                            self.viewPetitionButton.enabled = true
                        })
                        
                    }
                    
                }
                
                
            }
        }else{
            viewPetitionButton.enabled = false
            viewPetitionButton.alpha = 0
            petitionTextField.text = "No linked petition"
            
        }
        
    }
    
    
    
    
    //segue to web view controller to change.org homepage
    @IBAction func petitionButton(sender: UIButton) {
        
        //get url passed in
        let newURL = NSURL(string: petitionURL)
        
        //open in safari / (not webView due to problem with gathering url from some pages loaded in webView)
        UIApplication.sharedApplication().openURL(newURL!)
        
        
    }
    
    
    //Vote for solution
    @IBAction func voteSolutionClick(sender: UIButton) {
        
        _ = VoteForSolution(problemID:problemID,solutionID:solutionID){
            (result) in
            
        }
        
        var currentVoteCount = TempSave.sharedInstance().solutionVoteArray[self.index]
        currentVoteCount += 1
        TempSave.sharedInstance().solutionVoteArray[self.index] = currentVoteCount
        
        self.voteSolutionButton.enabled = false
        self.voteSolutionButton.alpha = 0
        
    }
    
}