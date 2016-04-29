//
//  UpdateCoreDataSolutions.swift
//  GoChange
//
//  Created by Nick Short on 24/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData


class UpdateCoreDataSolutions:NSObject{
    
    
    var existingChange:Change!
    var haveVotedArray:NSMutableArray = []
    
    
    init(change:Change){
        super.init()
        
        existingChange = change
        createCoreDataSolutions()
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func createCoreDataSolutions(){
        
        /*
        //clear core data of all existing solution ready for new set to be added
        let predicate = NSPredicate(format: "solutionToChange == %@", existingChange!)
        let fetchRequest = NSFetchRequest(entityName: "Solution")
        fetchRequest.predicate = predicate
        
        do{
            let fetchEntities = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Solution]
            
            for entity in fetchEntities{
                
                //TODO: get current state of coreData haveVoted before delete, needs to be added to an array, link to names/details so can assign to correct entity / need to assign newly added solutions with haveVoted = no.
                haveVotedArray.addObject(entity.haveVotedFor)
                
                self.sharedContext.deleteObject(entity)
            }
            
        }catch{
            //TODO: deal with errors
        }
        */
        
        
        for i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
        
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = TempChange.sharedInstance().solutionOwnerArray[i]
            
            
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToChange = existingChange!
       
        }
        
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
    }


}