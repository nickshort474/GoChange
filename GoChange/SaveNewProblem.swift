//
//  SaveNewProblem.swift
//  GoChange
//
//  Created by Nick Short on 24/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import CoreData
import Firebase


class SaveNewProblem:NSObject{
    
    
    var problemID:String?
    var newProblem:Problem!
    var solutionIDArray:NSMutableArray = []
    
    init(completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        saveProblemToFirebase()
        
        createCoreDataProblem(){
            (result) in
            
            completionHandler(result:result)
            
        }
        
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    
    func saveProblemToFirebase(){
        
        //let namesRef = Firebase(url:"https://gochange.firebaseio.com/problem/names")
        let namesRef = FIRDatabase.database().reference().child("problem/names")
        //create location with unique ID in firebase database
        
        let problemNameLocation = namesRef.childByAutoId()
        
        problemID = problemNameLocation.key
        
        let problemOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        
        // set up values to be saved
        let problemNameValues = ["ProblemName":TempSave.sharedInstance().problemName,"ProblemOwner": problemOwner!]
        
        //save name of problem to firebase
        problemNameLocation.setValue(problemNameValues)
        
        saveDetailsToFirebase()
        saveSolutionsToFirebase()
        
    }
    
    func saveDetailsToFirebase(){
        
        // create reference to details section of firebase
        //let problemDetailLocation = Firebase(url:"https://gochange.firebaseio.com/problem/details")
        let problemDetailLocation = FIRDatabase.database().reference().child("problem/details")
        // append unique ID to path
        let uniqueDetailLocation = problemDetailLocation.child(problemID!)
        
        //set up details values to be saved
        let problemDetailValues = ["ProblemDetail":TempSave.sharedInstance().problemDetail]
        
        uniqueDetailLocation.setValue(problemDetailValues)
        
    }
    
    
    func saveSolutionsToFirebase(){
        
        
        // create ref to solution count location
        //let solutionCountLocation = Firebase(url:"https://gochange.firebaseio.com/problem/solutionCount")
        let solutionCountLocation = FIRDatabase.database().reference().child("problem/solutionCount")
        
        let uniqueSolutionCountLocation = solutionCountLocation.child(problemID!)
        uniqueSolutionCountLocation.setValue(["SolutionCount":TempSave.sharedInstance().solutionNameArray.count])
        
        
        //create reference to solutions location in firebase
        //let problemSolutionsLocation = Firebase(url:"https://gochange.firebaseio.com/problem/solutions")
        let problemSolutionsLocation = FIRDatabase.database().reference().child("problem/solutions")
        
        let uniqueSolutionLocation = problemSolutionsLocation.child(problemID!)
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        
        //loop through solutions array
        for i in 0 ..< (TempSave.sharedInstance().solutionNameArray.count){
            
            //create unqiue location with ID within solutions section
            let uniqueSolutionReference = uniqueSolutionLocation.childByAutoId()
            
            //save unique locationID into IDArray so can be saved in coreData
            self.solutionIDArray.addObject(uniqueSolutionReference.key)
            
            
            //set solution values
            let problemSolutionValues = ["SolutionName":TempSave.sharedInstance().solutionNameArray[i],"SolutionDescription":TempSave.sharedInstance().solutionDetailArray[i],"SolutionVoteCount":0,"SolutionOwner":solutionOwner!,"PetitionURL":TempSave.sharedInstance().petitionURLArray[i]]
            
            //save values to firebase
            uniqueSolutionReference.setValue(problemSolutionValues)
        }
        
        
    }
    
    
    
    func createCoreDataProblem(completionHandler:(result:AnyObject)-> Void){
        
        var problemDictionary:[String:AnyObject] = [String:AnyObject]()
        
        // create core data problem dictionary
        problemDictionary[Problem.Keys.problemName] = TempSave.sharedInstance().problemName
        problemDictionary[Problem.Keys.problemDescription] = TempSave.sharedInstance().problemDetail
        problemDictionary[Problem.Keys.problemID] = self.problemID
        problemDictionary[Problem.Keys.solutionCount] = TempSave.sharedInstance().solutionNameArray.count
        
        let problemOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        problemDictionary[Problem.Keys.problemOwner] = problemOwner!
        
        
        //create problem object in core data
        newProblem = Problem(dictionary: problemDictionary,context: sharedContext)
        
        //create core data solution dictionary
        createCoreDataSolutions()
        
        
        do{
            
            try self.sharedContext.save()
            
        }catch{
            //TODO: Catch errors!
        }
        
        //completion handler to pass back newly created problem
        completionHandler(result: newProblem)
        
    }
    
    
    func createCoreDataSolutions(){
        
        let solutionOwner = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        
        for i in 0 ..< TempSave.sharedInstance().solutionNameArray.count{
            
            var solutionDictionary:[String:AnyObject] = [String:AnyObject]()
            
            solutionDictionary[Solution.Keys.solutionName] = TempSave.sharedInstance().solutionNameArray[i]
            solutionDictionary[Solution.Keys.solutionDescription] = TempSave.sharedInstance().solutionDetailArray[i]
            solutionDictionary[Solution.Keys.voteCount] = 0
            solutionDictionary[Solution.Keys.solutionID] = self.solutionIDArray[i]
            solutionDictionary[Solution.Keys.haveVotedFor] = "yes" //user created solution, can not be voted for themselves
            solutionDictionary[Solution.Keys.solutionOwner] = solutionOwner!
            solutionDictionary[Solution.Keys.petitionURL] = TempSave.sharedInstance().petitionURLArray[i]
            
            
            //create core data solution object
            let newSolution = Solution(dictionary: solutionDictionary,context: sharedContext)
            newSolution.solutionToProblem = newProblem!
            
            
        }
        
    }

    
    
}