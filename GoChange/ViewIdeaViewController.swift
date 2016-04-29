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
    
    
    var changeID:String!
    var solutionID:String!
    
    //var change:Change!
    //var viewControllerStatus:String!
    
    var loadedNameData:String!
    var loadedDetailData:String!
    
    //var solutionCount:Int!
   
    var index:Int!
    
    
    func viewWillLoad(){
        solutionNameField.enabled = false
        solutionDetailField.selectable = false
        
        voteSolutionButton.enabled = false
        voteSolutionButton.alpha = 0.5
    }
    
    
    override func viewWillAppear(animated: Bool) {
        solutionNameField.text = loadedNameData
        solutionDetailField.textColor = UIColor.blackColor()
        solutionDetailField.text = loadedDetailData
    
        //TODO: If haveVoted == "no"
        //voteSolutionButton.enabled = true
        //voteSolutionButton.alpha = 1
        
        //TODO: Create new controller class which checks haveVoted of coreData using changeID
        
    }
    
    
    
    @IBAction func petitionButton(sender: UIButton) {
        var controller:WebViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        
        
        //TODO: set petition URL saved somewhere?
        controller.urlString = GoChangeClient.Constants.dynamicPetitionURL
        
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
        self.voteSolutionButton.alpha = 0.5
        
    }
    
}