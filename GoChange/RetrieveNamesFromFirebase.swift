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
    
    var nameResults:[String] = []
    var ownerResults:[String] = []
    
    
    init(problemArray:[String],completionHandler:(nameResults:[String],ownerResults:[String])->Void){
        
        super.init()
        
        let nameRef = FIRDatabase.database().reference().child("problem/names")

        for i in 0 ..< problemArray.count{
            
            let newNameRef = nameRef.child(problemArray[i])
            
            newNameRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
                self.nameResults.append(snapshot.value!["ProblemName"] as! String)
                self.ownerResults.append(snapshot.value!["ProblemOwner"] as! String)
                
                if(self.nameResults.count == problemArray.count){
                    
                    completionHandler(nameResults:self.nameResults, ownerResults: self.ownerResults)
                    
                }
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
            
            
        }
        
        
        
    }
    
    
}