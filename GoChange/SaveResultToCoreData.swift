//
//  SaveResultToCoreData.swift
//  GoChange
//
//  Created by Nick Short on 24/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class SaveResultToCoreData:NSObject{
    
    var problemID:String!
    var newProblem:Problem!
    
    
    init(problemID:String,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        self.problemID = problemID
        
        createCoreDataProblem(){
            (result) in
            
            completionHandler(result:result)
        }
        
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func createCoreDataProblem(completionHandler:(result:AnyObject)->Void){
        
        var problemDictionary:[String:AnyObject] = [String:AnyObject]()
        
        // create core data problem dictionary
        problemDictionary[Problem.Keys.problemName] = TempSave.sharedInstance().problemName
        problemDictionary[Problem.Keys.problemDescription] = TempSave.sharedInstance().problemDetail
        problemDictionary[Problem.Keys.problemID] = self.problemID
        problemDictionary[Problem.Keys.solutionCount] = TempSave.sharedInstance().solutionNameArray.count
        problemDictionary[Problem.Keys.problemOwner] = TempSave.sharedInstance().problemOwner
        
        
        //create problem object in core data
        newProblem = Problem(dictionary: problemDictionary,context: sharedContext)
        
        //create core data solution dictionary
        createCoreDataSolutions()
        
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
        
        //completion handler to pass back newly created problem
        completionHandler(result: newProblem)
    }
    
    
    
    func createCoreDataSolutions(){
        
        
        for i in 0 ..< TempSave.sharedInstance().solutionNameArray.count{
            
            //TODO: sort new solution array problem...
            //When coming from coreDataFirebaseSolutionPost need to use newSolutionNameArray and newSolutionDetailArray
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempSave.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempSave.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempSave.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempSave.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = TempSave.sharedInstance().solutionOwnerArray[i]
            solutionDictionary[Solution.Keys.petitionURL] = TempSave.sharedInstance().petitionURLArray[i]
            
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            
            newSolution.solutionToProblem = newProblem!
            
            
        }
        
                
        
    }
    
    
}