//
//  RetrieveDetailsFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 05/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveDetailsFromFirebase:NSObject{
    
    var results:[String] = []
    
    init(userRefArray:[String],completionHandler:(results:[String])->Void){
        
        super.init()
        
        let ref = FIRDatabase.database().reference().child("problem/details")
        
        for i in 0 ..< userRefArray.count{
            
            let problemRef = ref.child(userRefArray[i])
            
            problemRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
            self.results.append(snapshot.value!["ProblemDetail"] as! String)
                
            if(self.results.count == userRefArray.count){
                    
                completionHandler(results:self.results)
                    
            }
                
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
        }
    }
    
    
}