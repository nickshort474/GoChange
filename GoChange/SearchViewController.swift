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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = GoChangeClient.Constants.customOrangeColor
        
        searchTextField.layer.masksToBounds = false
        //searchTextField.borderStyle = UITextBorderStyle.None
        searchTextField.layer.shadowRadius = 1.0
        searchTextField.layer.shadowColor = GoChangeClient.Constants.customOrangeColor.CGColor
        searchTextField.layer.shadowOffset = CGSizeMake(3.0,3.0)
        searchTextField.layer.shadowOpacity = 0.5
        
        searchActivity.hidden = true
        searchActivity.stopAnimating()
        
        
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
    
    
    func presentAlert(alertType:String){
        
        let controller = UIAlertController()
        //controller.title = "No Matches"
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


