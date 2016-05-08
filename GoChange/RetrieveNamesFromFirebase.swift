//
//  RetrieveNamesFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 29/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveNamesFromFirebase:NSObject{
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/problem/names")
    var nameResults:[String] = []
    var ownerResults:[String] = []
    
    
    init(problemArray:[String],completionHandler:(nameResults:[String],ownerResults:[String])->Void){
        
        super.init()
        
        for i in 0 ..< problemArray.count{
            
            let newRef = nameRef.childByAppendingPath(problemArray[i])
            
            newRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                self.nameResults.append(snapshot.value["ProblemName"] as! String)
                self.ownerResults.append(snapshot.value["ProblemOwner"] as! String)
                
                if(self.nameResults.count == problemArray.count){
                    
                    completionHandler(nameResults:self.nameResults, ownerResults: self.ownerResults)
                    
                }
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
            
            
        }
        
        
        
    }
    
    
}