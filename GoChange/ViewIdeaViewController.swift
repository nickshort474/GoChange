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
    @IBOutlet weak var thirdPetitionTextField: UITextField!
    
    
    var changeID:String!
    var solutionID:String!
    
    //var change:Change!
    var viewControllerStatus:String!
    
    var loadedNameData:String!
    var loadedDetailData:String!
    var petitionURL:String!
    //var solutionCount:Int!
   
    var index:Int!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        solutionNameField.enabled = false
        solutionDetailField.selectable = false
        
        petitionTextField.enabled = false
        
        
        if(petitionURL != ""){
        
            print(petitionURL)
            
            _ = ChangeOrgCode(petitionURL:petitionURL){
                result in
            
                print(result)
            }
        }else{
            viewPetitionButton.enabled = false
            viewPetitionButton.alpha = 0
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
       
        solutionNameField.text = loadedNameData
        solutionDetailField.textColor = UIColor.blackColor()
        solutionDetailField.text = loadedDetailData
    
        petitionTextField.text = petitionURL
        
        if(viewControllerStatus == "newChange" || viewControllerStatus == "results"){
            
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
                    self.voteSolutionButton.enabled = true
                    self.voteSolutionButton.alpha = 1
                }
            
            }
            
        }
       
        
    }
    
    
    
    @IBAction func petitionButton(sender: UIButton) {
        
        var controller:WebViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        
        controller.urlString = petitionURL
        controller.status = "viewing"
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    @IBAction func voteSolutionClick(sender: UIButton) {
        
        //Vote for solution
        _ = VoteForSolution(changeID:changeID,solutionID:solutionID){
            (result) in
            
        }
        
        var currentVoteCount = TempChange.sharedInstance().solutionVoteArray[self.index]
        currentVoteCount += 1
        TempChange.sharedInstance().solutionVoteArray[self.index] = currentVoteCount
        
        //decide whether to change button to Have Voted instead of alpha change
        self.voteSolutionButton.enabled = false
        self.voteSolutionButton.alpha = 0
        
    }
    
}