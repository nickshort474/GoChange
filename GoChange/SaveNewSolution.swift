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
    
    
    var existingChange:Change!
    var solutionIDArray:NSMutableArray = []
    
    
    init(change:Change,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        existingChange = change
        saveSolutionsToFirebase()
        createCoreDataSolutions()
        adjustCoreDataChange()
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    
    
    func saveSolutionsToFirebase(){
        
        let changeID = existingChange.changeID
        
        let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutionCount")
        let uniqueSolutionCountLocation = solutionCountLocation.childByAppendingPath(changeID)
        uniqueSolutionCountLocation.setValue(["SolutionCount":TempChange.sharedInstance().solutionNameArray.count])
        
        
        //create reference to solutions location in firebase
        let changeSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
        let uniqueSolutionLocation = changeSolutionsLocation.childByAppendingPath(changeID)
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        
        //loop through solutions array
        for i in 0 ..< (TempChange.sharedInstance().newSolutionNameArray.count){
            
            //create unqiue location with ID within solutions section
            let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()
            
            
            //save uniqueSolutionReference to array for later use
            self.solutionIDArray.addObject(uniqueSolutionReference.key)
            
            //set solution values
            let changeSolutionValues = ["SolutionName":TempChange.sharedInstance().newSolutionNameArray[i],"SolutionDescription":TempChange.sharedInstance().newSolutionDetailArray[i],"SolutionVoteCount":0,"SolutionOwner":solutionOwner,"PetitionURL":TempChange.sharedInstance().newPetitionURLArray[i]]
            
            //save values to firebase
            uniqueSolutionReference.setValue(changeSolutionValues)
        }
        
        
    }
    
    
    
    
    func createCoreDataSolutions(){
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        for i in 0 ..< TempChange.sharedInstance().newSolutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().newSolutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().newSolutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = 0
            solutionDictionary[Solution.Keys.solutionID] = self.solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = solutionOwner
            solutionDictionary[Solution.Keys.petitionURL] = TempChange.sharedInstance().newPetitionURLArray[i]
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToChange = existingChange!
            
        }
        
       
        
    }
    
    func adjustCoreDataChange(){
        
        let request = NSFetchRequest(entityName: "Change")
        let predicate = NSPredicate(format: "changeID == %@", existingChange.changeID)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Change]
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