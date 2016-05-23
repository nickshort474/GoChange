//
//  FindRecentProblem.swift
//  GoChange
//
//  Created by Nick Short on 10/05/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class FindRecentProblem:NSObject{
    
    var baseRef = FIRDatabase.database().reference().child("problem/")
    var problemKey:String!
    
    
    init(problemName:String,completionHandler:(results:FIRDataSnapshot,detailResult:AnyObject)->Void){
        super.init()
        
        let nameRef = baseRef.child("names")
        
        nameRef.queryOrderedByChild("ProblemName").queryEqualToValue(problemName).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            for problem in snapshot.children.allObjects{
                self.problemKey = problem.key
            }
            
            
            
            
            self.getProblemDetail({
                (detailResult) in
                                
                completionHandler(results:snapshot,detailResult:detailResult)
            })
            
            
            
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
        })
        
        
    }
    
    
    func getProblemDetail(completionHandler:(detailResults:AnyObject)->Void){
        
        let detailRef = baseRef.child("details").child(self.problemKey)
        
        
        detailRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            
            let detailResult = snapshot.value!["ProblemDetail"]!
            
            if let detailResult = detailResult{
                completionHandler(detailResults:detailResult)
            }
            
            
            
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
        })
    }
    
    
    
    
}