//
//  RetrieveChange.swift
//  GoChange
//
//  Created by Nick Short on 01/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class RetrieveChange:NSObject{
    
    
    init(changeID:String,completionHandler:(result:Change)-> Void){
       super.init()
        
        //let retrievedEntity:Change?
        
        let request = NSFetchRequest(entityName: "Change")
        let predicate = NSPredicate(format: "changeID == %@", changeID)
        request.predicate = predicate
        
        do{
           let results =  try sharedContext.executeFetchRequest(request) as! [Change]
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