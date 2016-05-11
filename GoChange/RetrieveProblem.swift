//
//  RetrieveProblem.swift
//  GoChange
//
//  Created by Nick Short on 01/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class RetrieveProblem:NSObject{
    
    
    init(problemID:String,completionHandler:(problemName:String,problemID:String)-> Void){
       super.init()
        
       
        
        let request = NSFetchRequest(entityName: "Problem")
        let predicate = NSPredicate(format: "problemID == %@", problemID)
        request.predicate = predicate
        
        do{
           let results =  try sharedContext.executeFetchRequest(request) as! [Problem]
            
            if let entity = results.first{
                
               let problemName = entity.problemName
               let problemID = entity.problemID
               
                completionHandler(problemName:problemName,problemID:problemID)
                
            }else{
                print("no result")
                completionHandler(problemName:"",problemID:"")
            }
            
        }catch{
            //TODO: catch errors
        }
        
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
       
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
    
}