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
    
    
    init(problemID:String,completionHandler:(result:Problem)-> Void){
       super.init()
        
       
        
        let request = NSFetchRequest(entityName: "Problem")
        let predicate = NSPredicate(format: "problemID == %@", problemID)
        request.predicate = predicate
        
        do{
           let results =  try sharedContext.executeFetchRequest(request) as! [Problem]
            if let entity = results.first{
                
               completionHandler(result:entity)
                
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