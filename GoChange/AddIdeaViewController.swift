//
//  AddIdeaViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class AddIdeaViewController: UIViewController {
    
    
    var petitionId:Int = 1
    var session = NSURLSession.sharedSession()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var addDetailButton: UIButton!
    
    var currentNameData:String!
    var currentDetailData:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.title = "Add Solution"
        addNameButton.hidden = true
        addDetailButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAddingIdea(sender: UIButton) {
        
        // save data locally and onto server
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelAddingIdea(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)        
    }
    
    
    @IBAction func addNameClick(sender: AnyObject) {
        var currentNameData = nameTextField.text
    }
    
    @IBAction func addDetailClick(sender: UIButton) {
        var currentDetailData = detailTextView.text
    }
    
    //-------------textfield methods ---------------
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addNameButton.hidden = false
    }
    
    
    
    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(textView.text == "Please enter details of the solution you have..."){
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        addDetailButton.hidden = false
        addNameButton.hidden = true
        
    }
    
    
    
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "tweakCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        cell.textLabel!.text = "Add a tweak"
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        var controller:AddTweakViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddTweakViewController") as! AddTweakViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
        
    }
    
    
    //---------------petition methods--------------------
    
    @IBAction func addPetition(sender: UIButton) {
        
        
        //TODO: put all petition code into outside file
        
        
        let parameterDictionary = [
            "api_key":GoChangeClient.Constants.apiKey,
            "petition_url":GoChangeClient.Constants.petitionURL
        ]
        
       let queryString =  GoChangeClient.sharedInstance().escapedParameters(parameterDictionary)
       let finalString = GoChangeClient.Constants.requestURL + queryString
       
       let url = NSURL(string: finalString)!
       let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request){
            data, response, downloadError in
            
            if downloadError != nil{
                
                //TODO: Deal with error
                print("error with request \(downloadError)")
                
            }else{
                
                GoChangeClient.sharedInstance().parseJSON(data!){
                    result,error in
                    
                    if error != nil{
                        //TODO: deal with error
                        print("error parsing JSON \(error)")
                    }else{
                        
                        self.petitionId = result["petition_id"] as! Int
                        print(self.petitionId)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
        
}


