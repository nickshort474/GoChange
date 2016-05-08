//
//  SaveNewSolution.swift
//  GoChange
//
//  Created by Nick Short on 24/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class SaveNewSolution:NSObject{
    
    
    var existingProblem:Problem!
    var solutionIDArray:NSMutableArray = []
    
    
    init(problem:Problem,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        existingProblem = problem
        saveSolutionsToFirebase()
        createCoreDataSolutions()
        adjustCoreDataProblem()
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    
    
    func saveSolutionsToFirebase(){
        
        let problemID = existingProblem.problemID
        
        let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/problem/solutionCount")
        let uniqueSolutionCountLocation = solutionCountLocation.childByAppendingPath(problemID)
        uniqueSolutionCountLocation.setValue(["SolutionCount":TempSave.sharedInstance().solutionNameArray.count])
        
        
        //create reference to solutions location in firebase
        let problemSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/problem/solutions")
        let uniqueSolutionLocation = problemSolutionsLocation.childByAppendingPath(problemID)
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        
        //loop through solutions array
        for i in 0 ..< (TempSave.sharedInstance().newSolutionNameArray.count){
            
            //create unqiue location with ID within solutions section
            let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()
            
            
            //save uniqueSolutionReference to array for later use
            self.solutionIDArray.addObject(uniqueSolutionReference.key)
            
            //set solution values
            let problemSolutionValues = ["SolutionName":TempSave.sharedInstance().newSolutionNameArray[i],"SolutionDescription":TempSave.sharedInstance().newSolutionDetailArray[i],"SolutionVoteCount":0,"SolutionOwner":solutionOwner,"PetitionURL":TempSave.sharedInstance().newPetitionURLArray[i]]
            
            //save values to firebase
            uniqueSolutionReference.setValue(problemSolutionValues)
        }
        
        
    }
    
    
    
    
    func createCoreDataSolutions(){
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        for i in 0 ..< TempSave.sharedInstance().newSolutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempSave.sharedInstance().newSolutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempSave.sharedInstance().newSolutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = 0
            solutionDictionary[Solution.Keys.solutionID] = self.solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = solutionOwner
            solutionDictionary[Solution.Keys.petitionURL] = TempSave.sharedInstance().newPetitionURLArray[i]
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToProblem = existingProblem!
            
        }
        
       
        
    }
    
    func adjustCoreDataProblem(){
        
        let request = NSFetchRequest(entityName: "Problem")
        let predicate = NSPredicate(format: "problemID == %@", existingProblem.problemID)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Problem]
            if let entity = results.first{
                
                var holdingSolutionCount = entity.solutionCount as Int
                holdingSolutionCount += 1
                entity.solutionCount = holdingSolutionCount
                
            }
            
        }catch{
            //TODO: catch errors
        }
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
    }
    
    
}