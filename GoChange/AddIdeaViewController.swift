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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.title = "Add Solution"
        
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
    
    
    
    
    //---------------petition methods--------------------
    
    @IBAction func addPetition(sender: UIButton) {
        
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


