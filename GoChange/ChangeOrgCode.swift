//
//  ChangeOrgCode.swift
//  GoChange
//
//  Created by Nick Short on 26/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation

class ChangeOrgCode:NSObject{
    
    var petitionId:Int = 1
    var session = NSURLSession.sharedSession()
    
    let parameterDictionary = [
        "api_key":GoChangeClient.Constants.apiKey,
        "petition_url":GoChangeClient.Constants.basePetitionURL
    ]
    
    override init(){
        super.init()
        
        
        
        
    }
    
    func performCall(){
    
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
                    
                    }
            }
        }
    }
    task.resume()
    }
    
}
