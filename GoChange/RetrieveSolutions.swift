//
//  RetrieveSolutions.swift
//  GoChange
//
//  Created by Nick Short on 03/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class RetrieveSolutions:NSObject{
    
    
    init(change:Change,completionHandler:(result:AnyObject)-> Void){
        super.init()
        
        //let retrievedEntity:Change?
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToChange == %@", change)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
            
            completionHandler(result:results)
            
            
        }catch{
            //TODO: catch errors
        }
        
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
    
}