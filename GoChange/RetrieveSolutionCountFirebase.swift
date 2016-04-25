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
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/change/solutionCount")
    var resultsArray:NSMutableArray = []
    
    init(changeArray:NSMutableArray,completionHandler:(results:NSMutableArray)->Void){
        super.init()
        
        for var i in 0 ..< changeArray.count{
            
            let solutionRef = nameRef.childByAppendingPath(changeArray[i] as! String)
            let countRef = solutionRef.childByAppendingPath("SolutionCount")
            
            countRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                self.resultsArray.addObject(snapshot.value)
                
                if(self.resultsArray.count == changeArray.count){
                    completionHandler(results:self.resultsArray)
                }
                
                
                
                
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
            
        }
        
        
        
        
        
        
        
        
    }
    
    
}