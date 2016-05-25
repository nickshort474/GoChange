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
    
    
    init(problem:Problem,completionHandler:(result:AnyObject)-> Void){
        super.init()
        
        // empty TempArrays ready to be populate with new data
        TempSave.sharedInstance().solutionNameArray = []
        TempSave.sharedInstance().solutionDetailArray = []
        TempSave.sharedInstance().solutionVoteArray = []
        TempSave.sharedInstance().solutionIDArray = []
        TempSave.sharedInstance().solutionOwnerArray = []
        TempSave.sharedInstance().petitionURLArray = []
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToProblem == %@", problem)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
            
            
            //assign results from coreData return to temp array then use TempArray for table
            for solution in results{
                
                TempSave.sharedInstance().solutionNameArray.append(solution.solutionName)
                TempSave.sharedInstance().solutionDetailArray.append(solution.solutionDescription)
                TempSave.sharedInstance().solutionVoteArray.append(solution.voteCount as Int)
                TempSave.sharedInstance().solutionIDArray.append(solution.solutionID)
                TempSave.sharedInstance().solutionOwnerArray.append(solution.solutionOwner)
                TempSave.sharedInstance().petitionURLArray.append(solution.petitionURL)
            }
            
            completionHandler(result:results)
            
            
        }catch{
        }
        
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
    
}