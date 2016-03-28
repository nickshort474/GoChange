//
//  CreateChange.swift
//  GoChange
//
//  Created by Nick Short on 07/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class CreateChange:NSObject{
    
    
    var ref = Firebase(url:"https://gochange.firebaseio.com/change")
    var savedAutoID:String = ""
    
    init(currentDetailData:String,currentNameData:String,owner:Bool) {
        super.init()
        
        if(owner == true){
            // save changes to firebase
            saveChangeToFirebase(currentDetailData,currentNameData: currentNameData)
            
            // get returned auto ID and save that along with other data to core data
            
            var change = createCoreDataChange(currentDetailData,currentNameData: currentNameData,owner:owner)
           
        }else{
            createCoreDataChange(currentDetailData,currentNameData: currentNameData,owner:owner)
        }
        
    
    }
    
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func saveChangeToFirebase(currentDetailData:String,currentNameData:String){
        
        let changeRef = ref.childByAutoId()
        savedAutoID = String(changeRef)
        
        
        let changeValues = ["ChangeName":currentNameData,"ChangeDetail":currentDetailData]
        
        changeRef.setValue(changeValues)
        
        
        
    }
    
    
    func createCoreDataChange(currentDetailData:String,currentNameData:String,owner:Bool) -> Change{
        
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        changeDictionary[Change.Keys.changeName] = currentNameData
        changeDictionary[Change.Keys.changeDescription] = currentDetailData
        changeDictionary[Change.Keys.owner] = owner
        changeDictionary[Change.Keys.firebaseLocation] = savedAutoID
        
      
        
        let newChange = Change(dictionary: changeDictionary,context: sharedContext)
        
        do{
            try self.sharedContext.save()
            print("change saved to core data")
        }catch{
            //TODO: Catch errors!
        }
        return newChange
    }
    
        
    
    
    
}