//
//  SaveData.swift
//  GoChange
//
//  Created by Nick Short on 28/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class SaveData:NSObject{
    
    var savedAutoID:String?
    var changeID:String?
    
    var solutionIDArray:NSMutableArray = []
    
    var newChange:Change!
    var existingChange:Change!
    var postType:String = ""
    var isOwner:String?
    
    var haveVoted:String = ""
    
    init(postType:String,owner:String? = nil,change:Change? = nil,changeID:String? = nil,completionHandler:(result:AnyObject)-> Void) {
        super.init()
        
        
        self.postType = postType
        self.isOwner = owner
        
        
        //TODO: RE-write as switch statement
        
        if(postType == "fullPost"){
            
            saveChangeToFirebase()
            createCoreDataChange(){
                (result) in
                
                completionHandler(result:result)
                
            }
            
        }else if(postType == "updateCoreDataSolutions"){
            
            // if just posting solutions...get change and link new solutions to existing change
            existingChange = change
            createCoreDataSolutions()
            
        }else if(postType == "coreDataFirebaseSolutionPost"){
            
            existingChange = change
            saveSolutionsToFirebase()
            createCoreDataSolutions()
        
        }else if(postType == "fullResultPost"){
            
            self.changeID = changeID
            
            createCoreDataChange(){
                (result) in
                
                completionHandler(result:result)
            }
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
        
        // set up values to be saved
        let changeNameValues = ["ChangeName":TempChange.sharedInstance().changeName]
        
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
        
        
        if(postType == "coreDataFirebaseSolutionPost"){
            // save only new solutions from newSolutionNameArray
            
           
            
            let changeID = existingChange.changeID
            
            let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutionCount")
            
            let uniqueSolutionCountLocation = solutionCountLocation.childByAppendingPath(changeID)
            
            uniqueSolutionCountLocation.setValue(["SolutionCount":TempChange.sharedInstance().solutionNameArray.count])
            
            
            //create reference to solutions location in firebase
            let changeSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
            
            //append changeID
            let uniqueSolutionLocation = changeSolutionsLocation.childByAppendingPath(changeID)
            
            //loop through solutions array
            for var i in 0 ..< (TempChange.sharedInstance().newSolutionNameArray.count){
                
                //create unqiue location with ID within solutions section
                let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()
                
                
                //save uniqueSolutionReference to array for later use
                self.solutionIDArray.addObject(uniqueSolutionReference.key)
                //TempChange.sharedInstance().solutionVoteArray[i].addObject(uniqueSolutionReference.key)
                
                
                //set solution values
                let changeSolutionValues = ["SolutionName":TempChange.sharedInstance().newSolutionNameArray[i],"SolutionDescription":TempChange.sharedInstance().newSolutionDetailArray[i],"SolutionVoteCount":TempChange.sharedInstance().solutionVoteArray[i]]
                
                //save values to firebase
                uniqueSolutionReference.setValue(changeSolutionValues)
            }
            
            
        }else{
            
            
            // create ref to solution count location
            let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutionCount")
            
            let uniqueSolutionCountLocation = solutionCountLocation.childByAppendingPath(changeID!)
            
            uniqueSolutionCountLocation.setValue(["SolutionCount":TempChange.sharedInstance().solutionNameArray.count])
            
            
            //create reference to solutions location in firebase
            let changeSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
            
            //append unique ID
            let uniqueSolutionLocation = changeSolutionsLocation.childByAppendingPath(changeID!)
            
            //loop through solutions array
            for var i in 0 ..< (TempChange.sharedInstance().solutionNameArray.count){
                
                //create unqiue location with ID within solutions section
                let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()
                
                
                //set solution values
                let changeSolutionValues = ["SolutionName":TempChange.sharedInstance().solutionNameArray[i],"SolutionDescription":TempChange.sharedInstance().solutionDetailArray[i],"SolutionVoteCount":TempChange.sharedInstance().solutionVoteArray[i]]
                
                //save values to firebase
                uniqueSolutionReference.setValue(changeSolutionValues)
            }
    
        }
    }
    
    
    
    func createCoreDataChange(completionHandler:(result:AnyObject)-> Void){
        
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        // create core data change dictionary
        changeDictionary[Change.Keys.changeName] = TempChange.sharedInstance().changeName
        changeDictionary[Change.Keys.changeDescription] = TempChange.sharedInstance().changeDetail
        changeDictionary[Change.Keys.owner] = self.isOwner
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
        
        // delete all solutions if any exist? ready for all solutions from firebase to be added.
        
        
        
        if(postType == "updateCoreDataSolutions"){
            
            let predicate = NSPredicate(format: "solutionToChange == %@", existingChange!)
            let fetchRequest = NSFetchRequest(entityName: "Solution")
            fetchRequest.predicate = predicate
            
            do{
                let fetchEntities = try self.sharedContext.executeFetchRequest(fetchRequest) as! [Solution]
                
                for entity in fetchEntities{
                    
                    //TODO: get current state of coreData haveVoted before delete
                    
                    haveVoted = entity.haveVotedFor
                    
                    self.sharedContext.deleteObject(entity)
                }
                
            }catch{
                //TODO: deal with errors
            }
       }
        
        
        
        //TODO: when coming from coreDataFirebaseSolutionPost need to loop through newSolutionNameArray
        if(postType == ""){
            
        }
        
        for var i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
           //TODO: sort new solution array problem...
            //When coming from coreDataFirebaseSolutionPost need to use newSolutionNameArray and newSolutionDetailArray
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            
           if(postType == "fullResultPost"){
                haveVoted = "yes"
            }else if(postType == "coreDataFirebaseSolutionPost"){
                haveVoted = "yes"
            }
            
            if(postType == "fullPost"){
                
                solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
                solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
                solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
                solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
                solutionDictionary[Solution.Keys.haveVotedFor] = "no"
                
            }else if(postType == "coreDataFirebaseSolutionPost"){
                
                solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().newSolutionNameArray[i]
                solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().newSolutionDetailArray[i]
                
                //TODO: verify values going in here
                solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i] // zero as new solution?
                
                
                solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
                solutionDictionary[Solution.Keys.haveVotedFor] = "no"
                
            }else if(postType == "fullResultPost"){
                
                solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
                solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
                solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
                solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
                solutionDictionary[Solution.Keys.haveVotedFor] = "no"
                
            }else if(postType == "updateCoreDataSolutions"){
                
                solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
                solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
                solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
                solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
                solutionDictionary[Solution.Keys.haveVotedFor] = haveVoted
                
            }
            
            
            
            
            //TODO: need to decide how to differentiate between initial creation of user solution so var is "yes"
            //And downloaded / followed solutions that are being saved to core data
            
           
            
            
            
            
           
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            
            
            //if creating a new change...
            if(postType == "fullPost" || postType == "fullResultPost"){
                
                newSolution.solutionToChange = newChange!
                
            }
            
            //if adding solutions to existing change
            if(postType == "updateCoreDataSolutions" || postType == "coreDataFirebaseSolutionPost"){
                
                newSolution.solutionToChange = existingChange!
                
            }
            
        }
        
        
        
    }
}