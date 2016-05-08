//
//  DeleteProblemFromCoreData.swift
//  GoChange
//
//  Created by Nick Short on 04/05/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData

class DeleteProblemFromCoreData:NSObject{
    
    var problem:Problem!
    
    init(problem:Problem){
        super.init()
        
        self.problem = problem
        
        deleteCoreDataSolutions()
        deleteCoreDataProblem()
        
    }
    
    func deleteCoreDataSolutions(){
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToProblem == %@", self.problem)
        
        request.predicate = predicate
        
        do{
            let results = try sharedContext.executeFetchRequest(request) as! [Solution]
            
            for entity in results{
                sharedContext.deleteObject(entity)
            }
            
        }catch{
            //TODO: deal with error
        }
        
    }
    
    
    func deleteCoreDataProblem(){
        
        let request = NSFetchRequest(entityName: "Problem")
        let predicate = NSPredicate(format: "problemName == %@", self.problem.problemName)
                
        request.predicate = predicate
        
        do{
            let results = try sharedContext.executeFetchRequest(request) as! [Problem]
           
            let entity = results.first
            if let entity = entity{
                
                sharedContext.deleteObject(entity)
                
            }
            
        }catch{
            //TODO: deal with error
        }
        
        
        do{
            try sharedContext.save()
        }catch{
            //TODO: deal with error
        }
        
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
       
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }()
    
    
    
    
}