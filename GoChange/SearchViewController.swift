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
    
    /*
    var returnedNameArray:[String] = []
    var returnedRefArray:[String] = []
    var matchedNameArray:[String] = []
    var countArray:[Int] = []
    var matchedRefArray:[String] = []
    var useNameArray:[String] = []
    var useOwnerArray:[String] = []
    var useDetailArray:[String] = []
    var useSolutionCountArray:[Int] = []
    var refsNotInCoreData:[String] = []
    */
    
    
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
        
        _ = SearchController(searchText: searchTextField.text!){
            (nameResult,detailResult,ownerResult,solutionCountResult,refResult) in
            
            var controller:ResultsViewController
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
            let navigationController = self.navigationController
            
            
            controller.resultNameArray = nameResult
            controller.resultDetailArray = detailResult
            controller.changeOwnerArray = ownerResult
            controller.resultSolutionCountArray = solutionCountResult
            controller.refArray = refResult
            
            
            navigationController?.pushViewController(controller,animated: true)
        }
        
        /*
        //clear arrays after previous search
        returnedRefArray = []
        returnedNameArray = []
        
        
        _ = RetrieveAllNamesFromFirebase(){
            (snapshot) in
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //add value of returned item to array
                self.returnedNameArray.append(name.value["ChangeName"]!! as! String)
                
                //add ref to item to another array
                self.returnedRefArray.append(String(name.key))
            }
            
            self.checkResults()
            self.createRefArray()
            
        }
         */
    }
    
    /*
    func checkResults(){
        
        //clear matched array after previous search
        matchedNameArray = []
        countArray = []
        
        let searchTerm = searchTextField.text!
        let capitalisedTerm = searchTerm.capitalizedString
        
        // create count variable to hold location of found search terms
        var count = 0
        
        for value in returnedNameArray{
            
            //convert value to string
            let valueString = String(value)
            
            //test for search term
            if (valueString.rangeOfString("\(searchTerm)") != nil){
                
                //if found add to matchedNameArray
                matchedNameArray.append(valueString)
                
                // add location of matched item within returned array to count array
                countArray.append(count)
                
            }
                
            // test for capitalized version of search term
            else if(valueString.rangeOfString("\(capitalisedTerm)") != nil){
                
                matchedNameArray.append(valueString)
                countArray.append(count)
            }
            
            count += 1
            
        }
        
        
        
    }
    
    func createRefArray(){
        
        //clear array after coming back from previous search
        useNameArray = []
        useOwnerArray = []
        useDetailArray = []
        matchedRefArray = []
        useSolutionCountArray = []
        
        // for all results that match search term add their unique reference to useRefArray using countArray
        for num in countArray{
           matchedRefArray.append(returnedRefArray[num])
        }
        
        //use useRefArray to Check if in core data based on reference
        self.checkIfInCoreData()
        
        // use refsNotInCoreData to collect all data from firebase
        _ = RetrieveDetailsFromFirebase(userRefArray: refsNotInCoreData){
            (result) in
            
            self.useDetailArray = result
            
            _ = RetrieveSolutionCountFirebase(changeArray:self.refsNotInCoreData){
                (result) in
               
                self.useSolutionCountArray = result
            
                _  = RetrieveNamesFromFirebase(changeArray:self.refsNotInCoreData){
                    (nameResults,ownerResults) in
            
                    self.useNameArray = nameResults
                    self.useOwnerArray = ownerResults
                    
                    self.sendToResults()
                }
            }
        }
       
        
    }
    
    func checkIfInCoreData(){
        
        //create array to hold references of coreData changes
        var followedRefArray:[String] = []
        
        // loop through search string matched useRefArray
        for i in 0 ..< matchedRefArray.count{
            
            _ = RetrieveChange(changeID: matchedRefArray[i] ){
                (result) in
                
                 followedRefArray.append(result.changeID)
            }
            
        }
       
        //gets useRef Array
        let setA = Set(followedRefArray)
        let setB = Set(matchedRefArray)
        
        let diff = setB.subtract(setA)
        refsNotInCoreData = Array(diff)
        
 
     
    }
   
    
    func sendToResults(){
        
        print(useNameArray)
        print(useOwnerArray)
        print(useDetailArray)
        print(useSolutionCountArray)
        
        print("changes not in core data \(refsNotInCoreData)")
        
        
        var controller:ResultsViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        let navigationController = self.navigationController
        
        
        controller.resultNameArray = useNameArray
        controller.changeOwnerArray = useOwnerArray
        controller.resultDetailArray = useDetailArray
        controller.resultSolutionCountArray = useSolutionCountArray
        controller.refArray = refsNotInCoreData
        
        
        
        navigationController?.pushViewController(controller,animated: true)
    }
     */
}


