//
//  PostData.swift
//  GoChange
//
//  Created by Nick Short on 28/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class PostData:NSObject{
    
    var savedAutoID:String?
    var changeID:String?
    
    //var ref = Firebase(url:"https://gochange.firebaseio.com/change/")
    
    
    init(postDictionary:[String:AnyObject]) {
        super.init()
        
        //TODO: If variable is only saving solutions...
        
        saveChangeToFirebase()
        createCoreDataChange()
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func saveChangeToFirebase(){
        
        //TODO: look into snapshot.key to get unique ID back from firebase?
        
        
        var namesRef = Firebase(url:"https://gochange.firebaseio.com/change/names")
        
        //create location with unique ID in firebase database
        let changeNameLocation = namesRef.childByAutoId()
        
        //save location as string for core data use
        savedAutoID = String(changeNameLocation)
        
        // copy location ready for mutation
        changeID = savedAutoID
        
        // create string of original firebase reference
        let refString = String(namesRef)
        
        //get range of original firebase reference
        let stringRange = savedAutoID?.rangeOfString(refString)
        
        //extract unique ID by removing original firebase reference from full location
        changeID!.removeRange(stringRange!)
        
        //clear leading character
        changeID?.removeAtIndex(changeID!.startIndex)
        
        
        // set up values to be saved
        let changeNameValues = ["ChangeName":TempChange.sharedInstance().changeName]
        
        //save name of change to firebase
        changeNameLocation.setValue(changeNameValues)
        
        // create reference to details section of firebase
        let changeDetailLocation = Firebase(url:"https://gochange.firebaseio.com/change/details")
        
        // append unique ID to path
        let uniqueDetailLocation = changeDetailLocation.childByAppendingPath(changeID!)
        
        //set up details values to be saved
        let changeDetailValues = ["ChangeDetail":TempChange.sharedInstance().changeDetail]
        
        uniqueDetailLocation.setValue(changeDetailValues)
        
        //create reference to solutions location in firebase
        let changeSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
        
        //append unique ID
        let uniqueSolutionLocation = changeSolutionsLocation.childByAppendingPath(changeID!)
        
        //loop through solutions array
        for var i in 0 ..< (TempChange.sharedInstance().solutionNameArray.count){
            
            
            //create unqiue location with ID within solutions section
            let uniqueSolutionReference = uniqueSolutionLocation!.childByAutoId()

            //set solution values
            let changeSolutionValues = ["SolutionName":TempChange.sharedInstance().solutionNameArray[i],"solutionDescription":TempChange.sharedInstance().solutionDetailArray[i]]
            
            //save values to firebase
            uniqueSolutionReference.setValue(changeSolutionValues)
        }
        
        
    }
    
    
    
    func createCoreDataChange(){
        
        // solutionArray to link to change
        var solutionArray = [Solution]()
        
        // create core data change dictionary
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        changeDictionary[Change.Keys.changeName] = TempChange.sharedInstance().changeName
        changeDictionary[Change.Keys.changeDescription] = TempChange.sharedInstance().changeDetail
        changeDictionary[Change.Keys.owner] = true
        changeDictionary[Change.Keys.firebaseLocation] = savedAutoID
        changeDictionary[Change.Keys.changeID] = changeID
        

        //create change object in core data
        let newChange = Change(dictionary: changeDictionary,context: sharedContext)
        
        
        //create core data solution dictionary
        
        for var i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
        
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
            
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
        
            solutionArray.append(newSolution)
            
            newSolution.solutionToChange = newChange
            
        }
        
        
        
        
        
        do{
            try self.sharedContext.save()
            print("change saved to core data")
        }catch{
            //TODO: Catch errors!
        }
        
    }
    
    
    
}