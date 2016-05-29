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
    
    
    var problemID:String!
    var solutionID:String!
    var currentVoteCount:Int = 0
    
    init(problemID:String,solutionID:String,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        self.problemID = problemID
        self.solutionID = solutionID
        
        addVoteToCoreData()
        addVoteToFirebase()
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        return sharedContext
        
    }()
    
    
    
    func addVoteToCoreData(){
        
        
        let predicate = NSPredicate(format: "solutionID == %@",solutionID)
        let fetchRequest = NSFetchRequest(entityName: "Solution")
        fetchRequest.predicate = predicate
        
        
 
        do{
            let fetchEntities = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Solution]
            
            let entity = fetchEntities.first
            
            //increase vote count
            var currentVoteCount = entity?.voteCount as! Int
            currentVoteCount += 1
            entity?.voteCount = currentVoteCount
            
            //change haveVotedFor to yes
            entity?.haveVotedFor = "yes"
            
        }catch{
        }
        
        do{
            try sharedContext.save()
        }catch{
        }
        
    }
    
    
    func addVoteToFirebase(){
        
        let ref = FIRDatabase.database().reference().child("problem/solutions")
        
        let childRef = ref.child(problemID).child(solutionID)
        print(childRef)
        
        childRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            self.currentVoteCount = snapshot.value!["SolutionVoteCount"] as! Int
            print(self.currentVoteCount)
            self.currentVoteCount += 1
            print(self.currentVoteCount)
            childRef.updateChildValues(["SolutionVoteCount":self.currentVoteCount])
            
            
        }, withCancelBlock:{error in
            print(error)
            print(error.localizedDescription)
            
            
        })
        
    }
    
    
}