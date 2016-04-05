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
    
    var returnedStringArray:NSMutableArray = []
    var returnedRefArray:NSMutableArray = []
    var countArray:NSMutableArray = []
    let useRefArray:NSMutableArray = []
    let foundArray:NSMutableArray = []
    
    
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
        
        _ = RetrieveFromFirebase(){
            (snapshot) in
            
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //TODO: add value of returned item to array
                //print(name.value["ChangeName"]!)
                
                self.returnedStringArray.addObject(name.value["ChangeName"]!! as! String)
                
                //TODO: add ref to item to another array
                self.returnedRefArray.addObject(String(name.key))
            }
            
            //TODO: call checkResults to compare returned strings search term
            print(self.returnedStringArray)
            print(self.returnedRefArray)
            
            
            
            self.checkResults()
            self.createRefArray()
            self.sendToResults()
        }
        
        
        
        
    }
    func checkResults(){
        
        let searchTerm = searchTextField.text!
        let capitalisedTerm = searchTerm.capitalizedString
        
        
        var count = 0
        //var returnStringArray = ["hello swift", "goodbye swift", "hello java", "goodbye android"]
        
        
        
        for value in returnedStringArray{
            
            let valueString = String(value)
            if (valueString.rangeOfString("\(searchTerm)") != nil){
                
                foundArray.addObject(valueString)
                countArray.addObject(count)
                
            }
            else if(valueString.rangeOfString("\(capitalisedTerm)") != nil){
                foundArray.addObject(valueString)
                countArray.addObject(count)
            }
            count += 1
            
        }
        
        print(foundArray)
        //print(countArray)
        
    }
    
    func createRefArray(){
        
        for num in countArray{
            let intOfNum = num as! Int
            useRefArray.addObject(returnedRefArray[intOfNum])
        }
        
        _ = RetrieveDetailsFromFirebase(userRefArray: useRefArray){
                (result) in
                
                
        }
        //print(useRefArray)
        
        
    }
    
    
    func sendToResults(){
        
        var controller:ResultsViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        let navigationController = self.navigationController
        
        controller.resultArray = foundArray
        controller.refArray = useRefArray
        
        navigationController?.pushViewController(controller,animated: true)
    }
    
}


