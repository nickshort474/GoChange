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
        
        
        // empty TempArrays ready to be populate with new data
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionVoteArray = []
        TempChange.sharedInstance().solutionIDArray = []
        TempChange.sharedInstance().solutionOwnerArray = []
        TempChange.sharedInstance().petitionURLArray = []
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToChange == %@", change)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
            
            
            //assign results from coreData return to temp array then use TempArray for table
            for solution in results{
                
                TempChange.sharedInstance().solutionNameArray.append(solution.solutionName)
                TempChange.sharedInstance().solutionDetailArray.append(solution.solutionDescription)
                TempChange.sharedInstance().solutionVoteArray.append(solution.voteCount as Int)
                TempChange.sharedInstance().solutionIDArray.append(solution.solutionID)
                TempChange.sharedInstance().solutionOwnerArray.append(solution.solutionOwner)
                TempChange.sharedInstance().petitionURLArray.append(solution.petitionURL)
            }
            
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