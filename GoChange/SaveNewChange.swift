//
//  SaveNewChange.swift
//  GoChange
//
//  Created by Nick Short on 24/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class SaveNewChange:NSObject{
    
    
    var changeID:String?
    var newChange:Change!
    var solutionIDArray:NSMutableArray = []
    
    init(completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        saveChangeToFirebase()
        
        createCoreDataChange(){
            (result) in
            
            completionHandler(result:result)
            
        }
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func saveChangeToFirebase(){
        
        let namesRef = Firebase(url:"https://gochange.firebaseio.com/change/names")
        
        //create location with unique ID in firebase database
        let changeNameLocation = namesRef.childByAutoId()
        
        changeID = changeNameLocation.key
        
        let changeOwner = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        
        // set up values to be saved
        let changeNameValues = ["ChangeName":TempChange.sharedInstance().changeName,"ChangeOwner": changeOwner!]
        
        //save name of change to firebase
        changeNameLocation.setValue(changeNameValues)
        
        saveDetailsToFirebase()
        saveSolutionsToFirebase()
        
    }
    
    func saveDetailsToFirebase(){
        
        // create reference to details section of firebase
        let changeDetailLocation = Firebase(url:"https://gochange.firebaseio.com/change/details")
        
        // append unique ID to path
        let uniqueDetailLocation = changeDetailLocation.childByAppendingPath(changeID!)
        
        //set up details values to be saved
        let changeDetailValues = ["ChangeDetail":TempChange.sharedInstance().changeDetail]
        
        uniqueDetailLocation.setValue(changeDetailValues)
        
    }
    
    
    func saveSolutionsToFirebase(){
        
        
        // create ref to solution count location
        let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutionCount")
        let uniqueSolutionCountLocation = solutionCountLocation.childByAppendingPath(changeID!)
        uniqueSolutionCountLocation.setValue(["SolutionCount":TempChange.sharedInstance().solutionNameArray.count])
        
        
        //create reference to solutions location in firebase
        let changeSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
        let uniqueSolutionLocation = changeSolutionsLocation.childByAppendingPath(changeID!)
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        
        //loop through solutions array
        for var i in 0 ..< (TempChange.sharedInstance().solutionNameArray.count){
            
            //create unqiue location with ID within solutions section
            let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()
            
            //save unique locationID into IDArray so can be saved in coreData
            self.solutionIDArray.addObject(uniqueSolutionReference.key)
            
            
            //set solution values
            let changeSolutionValues = ["SolutionName":TempChange.sharedInstance().solutionNameArray[i],"SolutionDescription":TempChange.sharedInstance().solutionDetailArray[i],"SolutionVoteCount":0,"SolutionOwner":solutionOwner!]
            
            //save values to firebase
            uniqueSolutionReference.setValue(changeSolutionValues)
        }
        
        
    }
    
    
    
    func createCoreDataChange(completionHandler:(result:AnyObject)-> Void){
        
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        // create core data change dictionary
        changeDictionary[Change.Keys.changeName] = TempChange.sharedInstance().changeName
        changeDictionary[Change.Keys.changeDescription] = TempChange.sharedInstance().changeDetail
        changeDictionary[Change.Keys.changeID] = self.changeID
        changeDictionary[Change.Keys.solutionCount] = TempChange.sharedInstance().solutionNameArray.count
        
        let changeOwner = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        changeDictionary[Change.Keys.changeOwner] = changeOwner!
        
        
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
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        
        for var i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = 0
            solutionDictionary[Solution.Keys.solutionID] = self.solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "yes" //user created solution, can not be voted for themselves
            solutionDictionary[Solution.Keys.solutionOwner] = solutionOwner!
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToChange = newChange!
            
            
        }
        
    }

    
    
}