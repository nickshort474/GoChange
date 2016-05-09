//
//  GetRandomProblem.swift
//  GoChange
//
//  Created by Nick Short on 09/05/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase

class GetRandomProblem:NSObject{
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/problem/names")
    
    init(completionHandler:(results:AnyObject)->Void){
        super.init()
        
        
        nameRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
        })
    }
    
    
}