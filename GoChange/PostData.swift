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
    var ref = Firebase(url:"https://gochange.firebaseio.com/change")
    
    
    init(postDictionary:[String:AnyObject]) {
        super.init()
        
        saveChangeToFirebase()
        createCoreDataChange()
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func saveChangeToFirebase(){
        
        let changeRef = ref.childByAutoId()
        savedAutoID = String(changeRef)
        
        
        let changeValues = ["ChangeName":TempChange.sharedInstance().changeName,"ChangeDetail":TempChange.sharedInstance().changeDetail]
        
        changeRef.setValue(changeValues)
        
        
        
        for var i in 0 ..< (TempChange.sharedInstance().solutionNameArray.count){
            
            //_ = CreateSolution(change:newChange, firebaseLocation:firebaseLocation,solutionName:TempChange.sharedInstance().solutionNameArray[i] as! String,solutionDescription:TempChange.sharedInstance().solutionDetailArray[i] as! String)
            let newChangeRef = changeRef!.childByAutoId()

            
            let newChangeValues = ["solutionName":TempChange.sharedInstance().solutionNameArray[i],"solutionDescription":TempChange.sharedInstance().solutionDetailArray[i]]
            
            newChangeRef.setValue(newChangeValues)
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

        //create change object in core data
        let newChange = Change(dictionary: changeDictionary,context: sharedContext)
        
        
        //create core data solution dictioary
        
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