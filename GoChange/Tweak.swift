//
//  Tweak.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class Tweak:NSManagedObject{
    
    struct Keys{
        static let tweakName = "tweakName"
        static let tweakDescription = "tweakDescription"
        
    }
    
    
    @NSManaged var tweakName:String
    @NSManaged var tweakDescription:String
    @NSManaged var tweakForSolution:Solution
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Change", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        tweakName = dictionary[Tweak.Keys.tweakName] as! String
        tweakDescription = dictionary[Tweak.Keys.tweakDescription] as! String
        
        
    }
    
    
    
    
}