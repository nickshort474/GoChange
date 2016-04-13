//
//  Change.swift
//  GoChange
//
//  Created by Nick Short on 26/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData


class Change:NSManagedObject{
    
    struct Keys{
        static let changeName = "changeName"
        static let changeDescription = "changeDescription"
        static let owner = "owner"
        static let firebaseLocation = "firebaseLocation"
        static let changeID = "changeID"
        static let solutionCount = "solutionCount"
    }
    
    
    @NSManaged var changeName:String
    @NSManaged var changeDescription:String
    @NSManaged var owner:String
    @NSManaged var changeID:String
    @NSManaged var solutionCount:NSNumber
    @NSManaged var changeNeedingSolution:[Solution]
    
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Change", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        changeName = dictionary[Change.Keys.changeName] as! String
        changeDescription = dictionary[Change.Keys.changeDescription] as! String
        changeID = dictionary[Change.Keys.changeID] as! String
        solutionCount = dictionary[Change.Keys.solutionCount] as! NSNumber
        owner = dictionary[Change.Keys.owner] as! String
        
               
    }
    
    
    
    
}