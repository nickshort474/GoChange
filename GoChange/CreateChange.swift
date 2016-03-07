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
    
    
    init(currentDetailData:String,currentNameData:String){
        super.init()
        createCoreDataChange(currentDetailData,currentNameData: currentNameData)
        saveChangeToFirebase(currentDetailData,currentNameData: currentNameData)
    }
    
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func createCoreDataChange(currentDetailData:String,currentNameData:String){
        
        var changeDictionary:[String:AnyObject] = [String:AnyObject]()
        
        changeDictionary[Change.Keys.changeName] = currentNameData
        changeDictionary[Change.Keys.changeDescription] = currentDetailData
    
        let newChange = Change(dictionary: changeDictionary,context: sharedContext)
    
        do{
            try self.sharedContext.save()
            print("change saved to core data")
        }catch{
            //TODO: Catch errors!
        }
    }
    
        
    func saveChangeToFirebase(currentDetailData:String,currentNameData:String){
        
        let changeRef = ref.childByAutoId()
        
        
        let changeValues = ["ChangeName":currentNameData,"ChangeDetail":currentDetailData]
        
        changeRef.setValue(changeValues)
        
        
        
    }
    
    
}