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
        static let voteCount = "voteCount"
        static let solutionID = "solutionID"
        static let haveVotedFor = "haveVotedFor"
        static let solutionOwner = "solutionOwner"
        static let petitionURL = "petitionURL"
    }
    
    
    @NSManaged var solutionName:String
    @NSManaged var solutionDescription:String
    @NSManaged var voteCount:NSNumber
    @NSManaged var solutionID:String
    @NSManaged var haveVotedFor:String
    @NSManaged var solutionOwner:String
    @NSManaged var petitionURL:String
    @NSManaged var solutionToProblem:Problem
    
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Solution", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        solutionName = dictionary[Solution.Keys.solutionName] as! String
        solutionDescription = dictionary[Solution.Keys.solutionDescription] as! String
        voteCount = dictionary[Solution.Keys.voteCount] as! Int
        solutionID = dictionary[Solution.Keys.solutionID] as! String
        haveVotedFor = dictionary[Solution.Keys.haveVotedFor] as! String
        solutionOwner = dictionary[Solution.Keys.solutionOwner] as! String
        petitionURL = dictionary[Solution.Keys.petitionURL] as! String
        
    }
   
}