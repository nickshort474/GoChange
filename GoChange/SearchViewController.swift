//
//  SearchViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!
    @IBOutlet weak var recentProblemStack: UIStackView!
    
    @IBOutlet weak var recentProblemsLabel: UILabel!
    
    
    var problemName:String!
    var problemDetail:String!
    var problemOwner:String!
    var problemID:String!
    
    var recentNameArray:[String] = []
    var refArray:[String] = []
    var matchedProblemArray:[String] = []
    var problemsNotInCoreData:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        self.navigationController?.navigationBar.barTintColor = GoChangeClient.Constants.customOrangeColor
        
        searchTextField.layer.masksToBounds = false
        searchTextField.layer.shadowRadius = 1.0
        searchTextField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        searchTextField.layer.shadowOffset = CGSizeMake(3.0,3.0)
        searchTextField.layer.shadowOpacity = 0.5
        
        searchActivity.hidden = true
        searchActivity.stopAnimating()
        
        //clear TempSave variables for
        TempSave.sharedInstance().retrievedRecentProblem = nil
        TempSave.sharedInstance().retrievedProblemFollowed = false
        TempSave.sharedInstance().RetrievedProblemsEmpty = false
        
        recentProblemsLabel.alpha = 1
        
        
        //gather recently added items from firebase
        _ =  GetRecentlyAdded(completionHandler: {
            (result) in
            
            //get name of problems and their unique ID's
            for name in result.children.allObjects{
                self.recentNameArray.append(name.value["ProblemName"] as! String)
                self.refArray.append(name.key)
            }
         
            //check whterh thes eitems are already followed (in core data)
            self.checkIfInCoreData()
            
         })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // if have clicked recent problem and come back
        if(TempSave.sharedInstance().retrievedRecentProblem != nil && TempSave.sharedInstance().retrievedProblemFollowed == true){
            
            recentProblemStack.removeArrangedSubview(TempSave.sharedInstance().retrievedRecentProblem)
            
        }
        
        if(TempSave.sharedInstance().RetrievedProblemsCount == 0 && TempSave.sharedInstance().RetrievedProblemsEmpty == true){
            self.recentProblemsLabel.alpha = 0
        }
        
    }
    
    
    
    func checkIfInCoreData(){
        
        //loop through each item in refArray and check against core data
        for id in self.refArray{
            
            _ = RetrieveProblem(problemID: id, completionHandler:{
                (resultName, resultID) in
                
                //add any matched item to matchedProblemArray
                self.matchedProblemArray.append(resultName)
                
                //once all items in refArray have been retrieved
                if(self.matchedProblemArray.count == self.refArray.count){
                   
                    //compare matchedArray to retrieved ref array
                    self.compareArrays()
                }
                
            })
        }
    }
    
    
    
    func compareArrays(){
        
        //create sets from both arrays
        let setA = Set(self.recentNameArray)
        let setB = Set(self.matchedProblemArray)
        
        //use diff to see which elements from retrieved firebase array don't exist in core data set
        let diff = setA.subtract(setB)
        self.problemsNotInCoreData = Array(diff)
        
        TempSave.sharedInstance().RetrievedProblemsCount = problemsNotInCoreData.count
        
        if(self.problemsNotInCoreData.count == 0){
            self.recentProblemsLabel.alpha = 0
        }
                
        //for each not matched element create button
        for name in problemsNotInCoreData{
            createButtons(name)
        }
        
    }
    
    
    func createButtons(name:String){
        
        //create buttons
        let button = UIButton()
        button.setTitle(name, forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.titleLabel?.font = UIFont(name:"System Bold", size: 11)
        button.addTarget(self,action:#selector(SearchViewController.buttonClick(_:)),forControlEvents: .TouchUpInside)
        
        //add buttons to existing stack view
        recentProblemStack.addArrangedSubview(button)
        
    }
    
    
    
    
    @IBAction func homeButtonClick(sender: UIButton) {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func searchForResults(sender: UIButton) {
        
        //set activity indicator
        searchActivity.hidden = false
        searchActivity.startAnimating()
        self.view.alpha = 0.5
        
        //search for result
        _ = SearchController(searchText: searchTextField.text!){
            (nameResult,detailResult,ownerResult,solutionCountResult,refResult,matchType) in
            
            // if no matches to search term present alert
            if(matchType == "noFirebaseMatches"){
                
                self.presentAlert("No matches for your search term")
                self.searchActivity.hidden = true
                self.searchActivity.stopAnimating()
                self.view.alpha = 01
                
            }else if(matchType == "coreDataMatch"){
               
                self.presentAlert("Matches found but already followed")
                self.searchActivity.hidden = true
                self.searchActivity.stopAnimating()
                self.view.alpha = 1
            
            }else{
                
                // if match found show result vc
                var controller:ResultsViewController
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
                let navigationController = self.navigationController
            
                controller.resultNameArray = nameResult
                controller.resultDetailArray = detailResult
                controller.problemOwnerArray = ownerResult
                controller.resultSolutionCountArray = solutionCountResult
                controller.refArray = refResult
            
                //set activity indicator
                self.searchActivity.hidden = true
                self.searchActivity.stopAnimating()
                self.view.alpha = 1
                
                navigationController?.pushViewController(controller,animated: true)
                
            }
        }
    }
    
    
    
    func buttonClick(sender:UIButton){
        
        //gather details of recent problem
        _ = FindRecentProblem(problemName: (sender.titleLabel?.text)!,completionHandler: {
            (result,detailResult) in
            
            //set values for problem
            for problem in result.children{
                self.problemID = problem.key
                self.problemName = problem.value["ProblemName"] as! String
                self.problemOwner = problem.value["ProblemOwner"] as! String
            }
            self.problemDetail = detailResult as! String
            
            //set retrievedRecentProblem var to whichever problem button was clicked
            TempSave.sharedInstance().retrievedRecentProblem = sender
            
            
            // present problem
            self.presentRecentProblem()
        })
    }
    
    
    //present View result controller
    func presentRecentProblem(){
        
        var controller:ViewResultViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewResultViewController") as! ViewResultViewController
        let navigationController = self.navigationController
        
        controller.problemName = self.problemName
        controller.problemDetail = self.problemDetail
        controller.problemID = self.problemID
        controller.owner = self.problemOwner
        
        
        navigationController?.pushViewController(controller,animated: true)
        
    }
    
    
    // present alerts
    func presentAlert(alertType:String){
        
        let controller = UIAlertController()
        controller.message = alertType
        
        let alertAction = UIAlertAction(title: "Please try again", style: UIAlertActionStyle.Cancel){
            action in
            
            self.searchTextField.text = ""
            self.searchTextField.becomeFirstResponder()
            
        }
        
        controller.addAction(alertAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
   
    
}


