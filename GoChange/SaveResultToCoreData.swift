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
    
    var changeID:String!
    var newChange:Change!
    
    
    init(changeID:String,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        self.changeID = changeID
        
        createCoreDataChange(){
            (result) in
            
            completionHandler(result:result)
        }
        
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func createCoreDataChange(completionHandler:(result:AnyObject)->Void){
        
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        // create core data change dictionary
        changeDictionary[Change.Keys.changeName] = TempChange.sharedInstance().changeName
        changeDictionary[Change.Keys.changeDescription] = TempChange.sharedInstance().changeDetail
        changeDictionary[Change.Keys.owner] = "no"
        changeDictionary[Change.Keys.changeID] = self.changeID
        changeDictionary[Change.Keys.solutionCount] = TempChange.sharedInstance().solutionNameArray.count
        
        //create change object in core data
        newChange = Change(dictionary: changeDictionary,context: sharedContext)
        
        //create core data solution dictionary
        createCoreDataSolutions()
        
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
        
        //completion handler to pass back newly created change
        completionHandler(result: newChange)
    }
    
    
    
    func createCoreDataSolutions(){
        
        
        for var i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
            //TODO: sort new solution array problem...
            //When coming from coreDataFirebaseSolutionPost need to use newSolutionNameArray and newSolutionDetailArray
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            
            newSolution.solutionToChange = newChange!
            
            
        }
        
                
        
    }
    
    
}