//
//  CreateSolution.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class CreateSolution:NSObject{
    
    
    var ref:Firebase?
    //var changeLocation:String?
    var linkedChange:Change?
    
    
    init(change:Change,firebaseLocation:String,solutionName:String,solutionDescription:String){
        super.init()
        
        ref = Firebase(url:"\(firebaseLocation)/solutions")
        //changeLocation = firebaseLocation
        linkedChange = change
        
        createCoreDataChange(solutionName,solutionDescription: solutionDescription)
        saveChangeToFirebase(solutionName,solutionDescription: solutionDescription)
        
        
        
    }
    
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func createCoreDataChange(solutionName:String,solutionDescription:String){
       
        var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
        
        
        solutionDictionary[Solution.Keys.solutionName] = solutionName
        solutionDictionary[Solution.Keys.solutionDescription] = solutionDescription
        
        
        let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
        newSolution.solutionToChange = linkedChange!
        
        
        do{
            print("attempting to save solution to core data")
            try self.sharedContext.save()
            print("solution saved to core data")
        }catch{
            //TODO: Catch errors!
        }
    }
    
    
    func saveChangeToFirebase(solutionName:String,solutionDescription:String){
        
        let changeRef = ref!.childByAutoId()
        
        
        let changeValues = ["solutionName":solutionName,"solutionDescription":solutionDescription]
        
        changeRef.setValue(changeValues)
        
        
        
    }
    
    
}
