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
    
    var ref = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
    var changeRef:Firebase!
    
    
    var change:Change!
    var changeID:String!
    
    var localSolutionIDArray:[String] = []
    var nonMatches:[String] = []
    
   
    
    init(changeID:String,change:Change? = nil,caller:String,completionHandler:(result:FDataSnapshot)->Void){
        super.init()
        
        if((change) != nil){
            self.change = change
        }
        self.changeID = changeID
        
        //empty TempArrays ready to be populate with new data
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionVoteArray = []
        TempChange.sharedInstance().solutionIDArray = []
        TempChange.sharedInstance().solutionOwnerArray = []
        TempChange.sharedInstance().petitionURLArray = []
        

        
        //setup reference to firebase using changeID
        changeRef = ref.childByAppendingPath(changeID)
        
        changeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            //loop through retrieved firebase solutions and save into TempArrays
            for solution in snapshot.children.allObjects as! [FDataSnapshot]{
                
                TempChange.sharedInstance().solutionIDArray.append(solution.key)
                TempChange.sharedInstance().solutionNameArray.append(solution.value["SolutionName"] as! String)
                TempChange.sharedInstance().solutionDetailArray.append(solution.value["SolutionDescription"] as! String)
                TempChange.sharedInstance().solutionVoteArray.append(solution.value["SolutionVoteCount"] as! Int)
                TempChange.sharedInstance().solutionOwnerArray.append(solution.value["SolutionOwner"] as! String)
                TempChange.sharedInstance().petitionURLArray.append(solution.value["PetitionURL"] as! String)
            }
            
            if(caller == "following"){
                self.createLocalArray()
            }
            
            
            //TODO: decide whather completion handler needed
            completionHandler(result: snapshot)

            
        },withCancelBlock: {error in
            print(error.description)
        })
        
        
    }
    
    func createLocalArray(){
        
        
        let request = NSFetchRequest(entityName: "Solution")
        let predicate = NSPredicate(format: "solutionToChange == %@", change)
        request.predicate = predicate
        
        do{
            let results =  try sharedContext.executeFetchRequest(request) as! [Solution]
            
            for solution in results{
                localSolutionIDArray.append(solution.solutionID)
            }
            
            compareArraysForMatches()
            
            
        }catch{
            //TODO: deal with errors
        }
            
    }
    
    func compareArraysForMatches(){
        
         //Test whether any of the solutions from firebase (held in TempChange) already exist in retrieved coredata array (localSolutionIDArray)
        /*
        for var i in 0 ..< TempChange.sharedInstance().solutionIDArray.count{
            
            for var j in 0 ..< localSolutionIDArray.count{
                
                
                if(TempChange.sharedInstance().solutionIDArray[i] as? String == localSolutionIDArray[j] as? String){
                    
                    // IF there is a match between a firebase solution and coreData remove it from arrays
                    /*
                    TempChange.sharedInstance().solutionIDArray.removeObjectAtIndex(i)
                    TempChange.sharedInstance().solutionNameArray.removeObjectAtIndex(i)
                    TempChange.sharedInstance().solutionDetailArray.removeObjectAtIndex(i)
                    TempChange.sharedInstance().solutionVoteArray.removeObjectAtIndex(i)
                    TempChange.sharedInstance().solutionOwnerArray.removeObjectAtIndex(i)
                    */
                }
            }
        }
        */
        
        //gets useRef Array
        let setA = Set(TempChange.sharedInstance().solutionIDArray)
        let setB = Set(localSolutionIDArray)
        
        let diff = setA.subtract(setB)
        nonMatches = Array(diff)
        
        retrieveMatchedSolutionsFromFirebase()
    }
    
    
    func retrieveMatchedSolutionsFromFirebase(){
        
        // clear tempArrays ready to load new solutions into
        TempChange.sharedInstance().solutionNameArray = []
        TempChange.sharedInstance().solutionDetailArray = []
        TempChange.sharedInstance().solutionVoteArray = []
        TempChange.sharedInstance().solutionIDArray = []
        TempChange.sharedInstance().solutionOwnerArray = []
        TempChange.sharedInstance().petitionURLArray = []
        
        
        // use diff to retrieve all data
        for i in 0 ..< nonMatches.count{
            
            let solutionRef = changeRef.childByAppendingPath(nonMatches[i])
            
            solutionRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
                
                TempChange.sharedInstance().solutionIDArray.append(snapshot.key)
                TempChange.sharedInstance().solutionNameArray.append(snapshot.value["SolutionName"] as! String)
                TempChange.sharedInstance().solutionDetailArray.append(snapshot.value["SolutionDescription"] as! String)
                TempChange.sharedInstance().solutionVoteArray.append(snapshot.value["SolutionVoteCount"] as! Int)
                TempChange.sharedInstance().solutionOwnerArray.append(snapshot.value["SolutionOwner"] as! String)
                TempChange.sharedInstance().petitionURLArray.append(snapshot.value["PetitionURL"] as! String)
                
                if(TempChange.sharedInstance().solutionIDArray.count == self.nonMatches.count){
                    
                    //TODO: call UpdateCoreDataSolutions class rather than function
                    
                    self.updateCoreDataSolutions()
                }
                
                
            },withCancelBlock: {error in
                
                print(error.description)
                
            })
 
        }
           
        
    }
    
    
    func updateCoreDataSolutions(){
        
        for i in 0 ..< TempChange.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempChange.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempChange.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = TempChange.sharedInstance().solutionVoteArray[i]
            solutionDictionary[Solution.Keys.solutionID] = TempChange.sharedInstance().solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "no"
            solutionDictionary[Solution.Keys.solutionOwner] = TempChange.sharedInstance().solutionOwnerArray[i]
            solutionDictionary[Solution.Keys.petitionURL] = TempChange.sharedInstance().petitionURLArray[i]
            
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToChange = change!
            
        }
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
    }
    
    
    lazy var sharedContext:NSManagedObjectContext = {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        return context
    }()
    
}