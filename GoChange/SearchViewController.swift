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
   
    @IBOutlet weak var recentProblem1: UIButton!
    @IBOutlet weak var recentProblem2: UIButton!
    @IBOutlet weak var recentProblem3: UIButton!
    @IBOutlet weak var recentProblem4: UIButton!
    
    var problemName:String!
    var problemDetail:String!
    var problemOwner:String!
    var problemID:String!
    
    var nameArray:[String] = []
    var refArray:[String] = []
    var matchedProblemArray:[String] = []
    
    var problemsNotInCoreData:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view did load")
        
        searchTextField.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = GoChangeClient.Constants.customOrangeColor
        
        searchTextField.layer.masksToBounds = false
        searchTextField.layer.shadowRadius = 1.0
        searchTextField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        searchTextField.layer.shadowOffset = CGSizeMake(3.0,3.0)
        searchTextField.layer.shadowOpacity = 0.5
        
        searchActivity.hidden = true
        searchActivity.stopAnimating()
        
        
        //TODO: Check firebase (create new section) for 4 recently added problems - can control which "Problems" get pushed to end users
        _ =  GetRecentlyAdded(completionHandler: {
            (result) in
            // result = list of problem names
            //add results to non match array
            for name in result.children.allObjects{
                self.nameArray.append(name.value["ProblemName"] as! String)
                self.refArray.append(name.key)
            }
            
           
            //Check core data to see if names exist in core data using; RetrieveProblem()
            for id in self.refArray{
                
                
                _ = RetrieveProblem(problemID: id, completionHandler:{
                    (result) in
                    
                    //result = [Problem] that do exist in core data, so remove from non match array
                    self.matchedProblemArray.append(result.problemName)
                    
                    print(self.matchedProblemArray)
                    print(self.nameArray)
                    
                    
                    let setA = Set(self.nameArray)
                    let setB = Set(self.matchedProblemArray)
                    
                    let diff = setB.subtract(setA)
                    self.problemsNotInCoreData = Array(diff)
                    print(self.problemsNotInCoreData)
                
                })
            }
        })
        //Get the problem names that don't exist in core data (non match array) and add names to titles of buttons
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButtonClick(sender: UIButton) {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func searchForResults(sender: UIButton) {
        
        searchActivity.hidden = false
        searchActivity.startAnimating()
        self.view.alpha = 0.5
        
        
        _ = SearchController(searchText: searchTextField.text!){
            (nameResult,detailResult,ownerResult,solutionCountResult,refResult,matchType) in
            
            if(matchType == "noFirebaseMatches"){
                
                self.presentAlert("No matches for your search term")
                
            }else if(matchType == "coreDataMatch"){
               
                self.presentAlert("Matches found but already followed")
                
            }else{
                
                var controller:ResultsViewController
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
                let navigationController = self.navigationController
            
                controller.resultNameArray = nameResult
                controller.resultDetailArray = detailResult
                controller.problemOwnerArray = ownerResult
                controller.resultSolutionCountArray = solutionCountResult
                controller.refArray = refResult
            
                
                self.searchActivity.hidden = true
                self.searchActivity.stopAnimating()
                self.view.alpha = 1
                navigationController?.pushViewController(controller,animated: true)
                
                
            }
        }
        
    }
    
    
    @IBAction func problem1Click(sender: UIButton) {
        
        _ = FindRecentProblem(problemName: (sender.titleLabel?.text)!,completionHandler: {
            (result,detailResult) in
            
            for problem in result.children{
                self.problemID = problem.key
                self.problemName = problem.value["ProblemName"] as! String
                self.problemOwner = problem.value["ProblemOwner"] as! String
            }
            self.problemDetail = detailResult as! String
            
            
            self.presentRecentProblem()
        })
        
        
    }
    
    
    @IBAction func problem2Click(sender: UIButton) {
        
        _ = FindRecentProblem(problemName: (sender.titleLabel?.text)!,completionHandler: {
            (result,detailResult) in
            print(result)
        })
        
    }
    
    @IBAction func problem3Click(sender: UIButton) {
        
        _ = FindRecentProblem(problemName: (sender.titleLabel?.text)!,completionHandler: {
            (result,detailResult) in
            print(result)
        })
        
    }
    
    @IBAction func problem4Click(sender: UIButton) {
        
        _ = FindRecentProblem(problemName: (sender.titleLabel?.text)!,completionHandler: {
            (result,detailResult) in
            print(result)
        })
        
    }
    
    
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


