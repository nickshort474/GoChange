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
    var returnedOwnerArray:NSMutableArray = []
    var useOwnerArray:NSMutableArray = []
    
    var returnedRefArray:NSMutableArray = []
    var countArray:NSMutableArray = []
    var matchedNameArray:NSMutableArray = []
    var useRefArray:NSMutableArray = []
    var useDetailArray:NSMutableArray = []
    var useSolutionCountArray:NSMutableArray = []
   
    
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
        
        print("new search")
        //clear arrays after previous search
        returnedRefArray = []
        returnedNameArray = []
        returnedOwnerArray = []
        
        _ = RetrieveFromFirebase(){
            (snapshot) in
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //add value of returned item to array
                self.returnedNameArray.addObject(name.value["ChangeName"]!! as! String)
                self.returnedOwnerArray.addObject(name.value["ChangeOwner"]!! as! String)
                
                //add ref to item to another array
                self.returnedRefArray.addObject(String(name.key))
            }
            
            self.checkResults()
            self.createRefArray()
            
        }
    }
    
    
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
        useOwnerArray = []
        
        // for all results that match search term add their unique reference to useRefArray using countArray
        for num in countArray{
           
            let intOfNum = num as! Int
            useRefArray.addObject(returnedRefArray[intOfNum])
            useOwnerArray.addObject(returnedOwnerArray[intOfNum])
        }
        
        // use refArray to collect details from firebase
        _ = RetrieveDetailsFromFirebase(userRefArray: useRefArray){
                (result) in
            
                self.useDetailArray = result
            
                _ = RetrieveSolutionCountFirebase(changeArray:self.useRefArray){
                    (result) in
               
                    self.useSolutionCountArray = result
                    self.checkIfInCoreData()
                    
                    
                }
        }
    }
    
    func checkIfInCoreData(){
        
        //TODO: check created arrays against coreData to see if already followed
        
        
        let followedChangeArray:NSMutableArray = []
       
        
        
        for var i in 0 ..< useRefArray.count{
            
            _ = RetrieveChange(changeID: useRefArray[i] as! String){
                (result) in
                
                //If exists in coreData result will return Change Object, add to followed Array
                followedChangeArray.addObject(result)
                
            }
            
        }
        
        //test follwoed array against retruened result and remove any changes already followed
        for var i in 0 ..< matchedNameArray.count{
            
            for element in followedChangeArray{
            
                var changeObject = element as! Change
           
                if matchedNameArray[i] as! String == changeObject.changeName {
                    self.matchedNameArray.removeObjectAtIndex(i)
                    self.useDetailArray.removeObjectAtIndex(i)
                    self.useSolutionCountArray.removeObjectAtIndex(i)
                    self.useRefArray.removeObjectAtIndex(i)
                    self.useOwnerArray.removeObjectAtIndex(i)
                }
            
            
            }
            
        }
        
        self.sendToResults()
    }
    
    func sendToResults(){
        
        
        
        var controller:ResultsViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        let navigationController = self.navigationController
        
        controller.resultNameArray = matchedNameArray
        controller.resultDetailArray = useDetailArray
        controller.resultSolutionCountArray = useSolutionCountArray
        controller.refArray = useRefArray
        controller.solutionOwnerArray = useOwnerArray
        
        
        navigationController?.pushViewController(controller,animated: true)
    }
    
}


