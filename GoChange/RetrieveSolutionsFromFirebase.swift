//
//  RetrieveSolutionsFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 06/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class RetrieveSolutionsFromFirebase:NSObject{
    
    var ref:FIRDatabaseReference!
    var problemRef:FIRDatabaseReference!
    var problem:Problem!
    var problemID:String!
    var localSolutionIDArray:[String] = []
    var nonMatches:[String] = []
    
    
    init(problemID:String,problem:Problem? = nil,caller:String,completionHandler:(result:FIRDataSnapshot)->Void){
        super.init()
        
        ref = FIRDatabase.database().reference().child("problem/solutions")        
        
        if((problem) != nil){
            self.problem = problem
        }
        self.problemID = problemID
        
        //empty TempArrays ready to be populate with new data
        TempSave.sharedInstance().solutionNameArray = []
        TempSave.sharedInstance().solutionDetailArray = []
        TempSave.sharedInstance().solutionVoteArray = []
        TempSave.sharedInstance().solutionIDArray = []
        TempSave.sharedInstance().solutionOwnerArray = []
        TempSave.sharedInstance().petitionURLArray = []
        

        
        //setup reference to firebase using problemID
        problemRef = ref.child(problemID)
        
        problemRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            //loop through retrieved firebase solutions and save into TempArrays
            for solution in snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                TempSave.sharedInstance().solutionIDArray.append(solution.key)
                TempSave.sharedInstance().solutionNameArray.append(solution.value!["SolutionName"] as! String)
                TempSave.sharedInstance().solutionDetailArray.append(solution.value!["SolutionDescription"] as! String)
                TempSave.sharedInstance().solutionVoteArray.append(solution.value!["SolutionVoteCount"] as! Int)
                TempSave.sharedInstance().solutionOwnerArray.append(solution.value!["SolutionOwner"] as! String)
                TempSave.sharedInstance().petitionURLArray.append(solution.value!["PetitionURL"] as! String)
            }
            
            if(caller == "following"){
                self.createLocalArray()
            }
            
            completionHandler(result: snapshot)

            
        },withCancelBlock: {error in
            print(error.description)
        })
        
        
    }
    
    func createLocalArray(){
        
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToProblem == %@", problem)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
            
            for solution in results{
                localSolutionIDArray.append(solution.solutionID)
            }
            
            compareArraysForMatches()
            
            
        }catch{
        }
            
    }
    
    func compareArraysForMatches(){
        
        //gets useRef Array
        let setA = Set(TempSave.sharedInstance().solutionIDArray)
        let setB = Set(localSolutionIDArray)
        
        let diff = setA.subtract(setB)
        nonMatches = Array(diff)
        
        retrieveMatchedSolutionsFromFirebase()
    }
    
    
    func retrieveMatchedSolutionsFromFirebase(){
        
        // clear tempArrays ready to load new solutions into
        TempSave.sharedInstance().solutionNameArray = []
        TempSave.sharedInstance().solutionDetailArray = []
        TempSave.sharedInstance().solutionVoteArray = []
        TempSave.sharedInstance().solutionIDArray = []
        TempSave.sharedInstance().solutionOwnerArray = []
        TempSave.sharedInstance().petitionURLArray = []
        
        
        // use diff to retrieve all data
        for i in 0 ..< nonMatches.count{
            
            let solutionRef = problemRef.child(nonMatches[i])
            
            solutionRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
                
                TempSave.sharedInstance().solutionIDArray.append(snapshot.key)
                TempSave.sharedInstance().solutionNameArray.append(snapshot.value!["SolutionName"] as! String)
                TempSave.sharedInstance().solutionDetailArray.append(snapshot.value!["SolutionDescription"] as! String)
                TempSave.sharedInstance().solutionVoteArray.append(snapshot.value!["SolutionVoteCount"] as! Int)
                TempSave.sharedInstance().solutionOwnerArray.append(snapshot.value!["SolutionOwner"] as! String)
                TempSave.sharedInstance().petitionURLArray.append(snapshot.value!["PetitionURL"] as! String)
                
                if(TempSave.sharedInstance().solutionIDArray.count == self.nonMatches.count){
                    
                    self.updateCoreDataSolutions()
                }
                
                
            },withCancelBlock: {error in
                
                print(error.description)
                
            })
 
        }
           
        
    }
    
    
    func updateCoreDataSolutions(){
        
        for i in 0 ..< TempSave.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempSave.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempSave.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempSave.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempSave.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = TempSave.sharedInstance().solutionOwnerArray[i]
            solutionDictionary[Solution.Keys.petitionURL] = TempSave.sharedInstance().petitionURLArray[i]
            
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToProblem = problem!
            
        }
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
        }
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
}