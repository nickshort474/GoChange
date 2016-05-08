//
//  Problem.swift
//  GoChange
//
//  Created by Nick Short on 26/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData


class Problem:NSManagedObject{
    
    struct Keys{
        static let problemName = "problemName"
        static let problemDescription = "problemDescription"
        static let firebaseLocation = "firebaseLocation"
        static let problemID = "problemID"
        static let solutionCount = "solutionCount"
        static let problemOwner = "problemOwner"
    }
    
    
    @NSManaged var problemName:String
    @NSManaged var problemDescription:String
    @NSManaged var problemID:String
    @NSManaged var solutionCount:NSNumber
    @NSManaged var problemOwner:String
    @NSManaged var problemNeedingSolution:[Solution]
    
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Problem", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        problemName = dictionary[Problem.Keys.problemName] as! String
        problemDescription = dictionary[Problem.Keys.problemDescription] as! String
        problemID = dictionary[Problem.Keys.problemID] as! String
        solutionCount = dictionary[Problem.Keys.solutionCount] as! NSNumber
        problemOwner = dictionary[Problem.Keys.problemOwner] as! String
               
    }
        
    
}