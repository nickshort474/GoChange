//
//  VoteForSolution.swift
//  GoChange
//
//  Created by Nick Short on 20/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase


class VoteForSolution:NSObject{
    
    var change:Change!
    var changeID:String!
    var solutionID:String!
    var currentVoteCount:Int = 0
    
    init(change:Change,changeID:String,solutionID:String,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        self.change = change
        self.changeID = changeID
        self.solutionID = solutionID
        
        addVoteToCoreData()
        addVoteToFirebase()
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        return sharedContext
        
    }()
    
    
    
    func addVoteToCoreData(){
        
        //TODO: Sort issue when switching between solutions viewed
        //Still on same change, whichever solution viewed and only incrementing on fetchEntities.first!! 
        //Only interacting with first solution!
        
        let predicate = NSPredicate(format: "solutionID == %@",solutionID)
        let fetchRequest = NSFetchRequest(entityName: "Solution")
        fetchRequest.predicate = predicate
        
        //let predicate = NSPredicate(format: "solutionToChange == %@", change)
 
        do{
            let fetchEntities = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Solution]
            
            let entity = fetchEntities.first
            var currentVoteCount = entity?.voteCount as! Int
            
            //print("old cd voteCount = \(currentVoteCount)")
            
            currentVoteCount += 1
            
            //print("new cd voteCount = \(currentVoteCount)")
            entity?.voteCount = currentVoteCount //as NSNumber
            
            
        }catch{
            //TODO: deal with errors
        }
        
        do{
            try sharedContext.save()
        }catch{
            //TODO: deal with errors
        }
        
    }
    
    
    func addVoteToFirebase(){
        
        
        let ref = Firebase(url: "https://gochange.firebaseio.com/change/solutions")
        let childRef = ref.childByAppendingPath(changeID).childByAppendingPath(solutionID)
        
        
        childRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            self.currentVoteCount = snapshot.value["SolutionVoteCount"] as! Int
            self.currentVoteCount += 1
            childRef.updateChildValues(["SolutionVoteCount":self.currentVoteCount])
            
            
        }, withCancelBlock:{error in
            
            //TODO: deal with error
            
        })
        
    }
    
    
}