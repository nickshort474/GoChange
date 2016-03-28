//
//  Solution.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class Solution:NSManagedObject{
    
    struct Keys{
        static let solutionName = "solutionName"
        static let solutionDescription = "solutionDescription"
        
    }
    
    
    @NSManaged var solutionName:String
    @NSManaged var solutionDescription:String
    
    @NSManaged var solutionToChange:Change
    @NSManaged var solutionNeedingTweaking:[Tweak]
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Solution", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        solutionName = dictionary[Solution.Keys.solutionName] as! String
        solutionDescription = dictionary[Solution.Keys.solutionDescription] as! String
        
    }
   
}