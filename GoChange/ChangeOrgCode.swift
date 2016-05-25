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
    
    var parameterDictionary = [String:AnyObject]()
    
    
    init(petitionURL:String,completionHandler:(result:AnyObject)-> Void){
        super.init()
        
        parameterDictionary = [
            "api_key":GoChangeClient.Constants.apiKey,
            "petition_url":petitionURL
        ]
        
        performCall({
           result in
            
            self.gatherPetitionData(result,completionHandler: {
                result in
                
                completionHandler(result: result)
                
            })
            
        })
        
    }
    
    func performCall(completionHandler:(result:Int)->Void){
    
        let queryString =  GoChangeClient.sharedInstance().escapedParameters(parameterDictionary)
        let finalString = GoChangeClient.Constants.requestIDURL + queryString
    
        let url = NSURL(string: finalString)!
        let request = NSURLRequest(URL: url)
    
        let task = session.dataTaskWithRequest(request){
            data, response, downloadError in
        
            if downloadError != nil{
            
                print("error with request \(downloadError)")
            
            }else{
            
                GoChangeClient.sharedInstance().parseJSON(data!){
                    result,error in
                
                    if error != nil{
                        
                        print("error parsing JSON \(error)")
                        
                    }else{
                    
                        self.petitionId = result["petition_id"] as! Int
                        completionHandler(result: self.petitionId)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func gatherPetitionData(result:Int,completionHandler:(result:AnyObject)-> Void){
        
        
        let parameterDictionary = [
            "api_key":GoChangeClient.Constants.apiKey,
             "fields":"title,url,signature_count"
        ]
        
        
        let queryString =  GoChangeClient.sharedInstance().escapedParameters(parameterDictionary)
        let finalString = GoChangeClient.Constants.requestPetitionInfoURL + "\(result)" + queryString
        let url = NSURL(string: finalString)!
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request){
            data, response, downloadError in
            
            if downloadError != nil{
                
                print("error with request \(downloadError)")
                
            }else{
                
                GoChangeClient.sharedInstance().parseJSON(data!){
                    result,error in
                    
                    if error != nil{
                        
                        print("error parsing JSON \(error)")
                        
                    }else{
                        completionHandler(result: result)
                        
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
}
