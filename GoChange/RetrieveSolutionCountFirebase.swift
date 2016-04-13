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
    
    
    init(changeID:String,completionHandler:(results:FDataSnapshot)->Void){
        
        super.init()
        
        let solutionRef = nameRef.childByAppendingPath(changeID)
        let countRef = solutionRef.childByAppendingPath("SolutionCount")
        
        
        countRef.observeEventType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
            
            }, withCancelBlock:{ error in
                
                print("error retrieving data")
                print(error.description)
                
        })
        
    }
    
    
}