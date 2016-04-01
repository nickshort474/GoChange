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
    
    
    init(changeID:String,completionHandler:AnyObject){
       super.init()
        
        let request = NSFetchRequest(entityName: "change")
        let predicate = NSPredicate(format: "changeID == %@", changeID)
        request.predicate = predicate
        
        do{
            try sharedContext.executeFetchRequest(request)
        }catch{
            //TODO: catch errors
        }
        
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
       
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
    
}