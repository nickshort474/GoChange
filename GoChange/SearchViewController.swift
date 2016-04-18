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
    
    var useRefArray:NSMutableArray = []
    var matchedNameArray:NSMutableArray = []
    var useDetailArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
        
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
        
        //clear arrays after previous search
        returnedRefArray = []
        returnedNameArray = []
        
        _ = RetrieveFromFirebase(){
            (snapshot) in
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //add value of returned item to array
                self.returnedNameArray.addObject(name.value["ChangeName"]!! as! String)
                
                //add ref to item to another array
                self.returnedRefArray.addObject(String(name.key))
            }
            
            //TODO: check refArray changeID's against local core data change ID's
            
            self.checkResults()
            self.createRefArray()
            
        }
    }
    
    
    func checkResults(){
        
        //clear matched array after previous search
        matchedNameArray = []
        
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
        
        //clear array after coming back from previous search
        useDetailArray = []
        useRefArray = []
        
        // for all results that match search term add their unique reference to useRefArray using countArray
        
        for num in countArray{
            let intOfNum = num as! Int
            
            useRefArray.addObject(returnedRefArray[intOfNum])
        }
        
        // use refArray to collect details from firebase
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


