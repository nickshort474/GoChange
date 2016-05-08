//
//  RetrieveSolutionCountFirebase.swift
//  GoChange
//
//  Created by Nick Short on 08/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveSolutionCountFirebase:NSObject{
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/problem/solutionCount")
    var resultsArray:[Int] = []
    
    init(problemArray:[String],completionHandler:(results:[Int])->Void){
        super.init()
        
        for i in 0 ..< problemArray.count{
            
            let solutionRef = nameRef.childByAppendingPath(problemArray[i])
            let countRef = solutionRef.childByAppendingPath("SolutionCount")
            
            countRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                self.resultsArray.append(snapshot.value as! Int)
                
                if(self.resultsArray.count == problemArray.count){
                    completionHandler(results:self.resultsArray)
                }
                
                
                
                
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
            
        }
        
        
        
        
        
        
        
        
    }
    
    
}