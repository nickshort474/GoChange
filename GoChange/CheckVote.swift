//
//  CheckVote.swift
//  GoChange
//
//  Created by Nick Short on 30/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class CheckVote:NSObject{
    
    
    
    init(solutionID:String,completionHandler:(result:Solution)-> Void){
        super.init()
        
        
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionID == %@", solutionID)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
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