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
    
    var returnedNameArray:NSMutableArray = []
    var returnedRefArray:NSMutableArray = []
   
    var countArray:NSMutableArray = []
    
    let useRefArray:NSMutableArray = []
    let matchedNameArray:NSMutableArray = []
    var useDetailArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
        
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
        
        //var searchTerm = searchTextField.text
        
        var changeID = ""
        
        _ = RetrieveFromFirebase(changeID:changeID){
            (snapshot) in
            
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //TODO: add value of returned item to array
                //print(name.value["ChangeName"]!)
                
                self.returnedNameArray.addObject(name.value["ChangeName"]!! as! String)
                
                //TODO: add ref to item to another array
                self.returnedRefArray.addObject(String(name.key))
            }
            
            self.checkResults()
            self.createRefArray()
            
        }
        
        
        
        
    }
    func checkResults(){
        
        
        let searchTerm = searchTextField.text!
        let capitalisedTerm = searchTerm.capitalizedString
        
        // create count variable to hold location of found search terms
        var count = 0
        
        for value in returnedNameArray{
            
            //convert value to string
            let valueString = String(value)
            
            //test for search term
            if (valueString.rangeOfString("\(searchTerm)") != nil){
                
                //if found add to foundArray
                matchedNameArray.addObject(valueString)
                
                // add location of matched item within returned array to count array
                countArray.addObject(count)
                
            }
                
            // test for capitalized version of search term
            else if(valueString.rangeOfString("\(capitalisedTerm)") != nil){
                
                matchedNameArray.addObject(valueString)
                countArray.addObject(count)
            }
            
            // increment count
            count += 1
            
        }
        
        
        
    }
    
    func createRefArray(){
        
        
        // for all results that match search term add their unique reference to useRefArray using countArray
        
        for num in countArray{
            let intOfNum = num as! Int
            
            useRefArray.addObject(returnedRefArray[intOfNum])
        }
        
        _ = RetrieveDetailsFromFirebase(userRefArray: useRefArray){
                (result) in
            
            self.useDetailArray = result
            self.sendToResults()
        }
        
        
        
        
        
    }
    
    
    func sendToResults(){
        
        
        
        var controller:ResultsViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        let navigationController = self.navigationController
        
        controller.resultNameArray = matchedNameArray
        
        controller.resultDetailArray = useDetailArray
        controller.refArray = useRefArray
        
        navigationController?.pushViewController(controller,animated: true)
    }
    
}


