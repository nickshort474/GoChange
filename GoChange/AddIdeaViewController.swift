//
//  AddIdeaViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class AddIdeaViewController: UIViewController {
    
    var apiKey = "1a4f569e8857b5ce19ed32d20b799f1e8d922b8b3bd5413cbaa8fb9c2664ad41"
    
    var requestURL = "https://api.change.org/v1/petitions/get_id"
    var petitionURL = "http://www.change.org/p/dunkin-donuts-stop-using-styrofoam-cups-and-switch-to-a-more-eco-friendly-solution"

    var session = NSURLSession.sharedSession()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    
    @IBAction func addPetition(sender: UIButton) {
        
        let parameterDictionary = [
            "api_key":apiKey,
            "petition_url":petitionURL
        ]
        
       let queryString =  GoChangeClient.sharedInstance().escapedParameters(parameterDictionary)
       let finalString = requestURL + queryString
       
        print(finalString)
       
       let url = NSURL(string: finalString)!
        
       let request = NSURLRequest(URL: url)
        
        print("request created")
        
        let task = session.dataTaskWithRequest(request){
            data, response, downloadError in
            
            print("task returned")
            
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
                       print(result)
                        print(result["petition_id"])
                        print(result["result"])
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
        
}


