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
    
    
    var existingProblem:Problem!
    var haveVotedArray:NSMutableArray = []
    
    
    init(problem:Problem){
        super.init()
        
        existingProblem = problem
        createCoreDataSolutions()
        
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func createCoreDataSolutions(){
        
        
        for i in 0 ..< TempSave.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
        
            solutionDictionary[Solution.Keys.solutionName] = TempSave.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempSave.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempSave.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempSave.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = TempSave.sharedInstance().solutionOwnerArray[i]
            solutionDictionary[Solution.Keys.petitionURL] = TempSave.sharedInstance().petitionURLArray[i]
            
            
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToProblem  = existingProblem!
       
        }
        
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
        }
    }


}