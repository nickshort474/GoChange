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
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/change/names")
    var nameResults:[String] = []
    var ownerResults:[String] = []
    
    
    init(changeArray:[String],completionHandler:(nameResults:[String],ownerResults:[String])->Void){
        
        super.init()
        
        for i in 0 ..< changeArray.count{
            
            let newRef = nameRef.childByAppendingPath(changeArray[i])
            
            newRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                self.nameResults.append(snapshot.value["ChangeName"] as! String)
                self.ownerResults.append(snapshot.value["ChangeOwner"] as! String)
                
                if(self.nameResults.count == changeArray.count){
                    
                    completionHandler(nameResults:self.nameResults, ownerResults: self.ownerResults)
                    
                }
            
            }, withCancelBlock:{ error in
                
                print(error.description)
                
            })
            
            
        }
        
        
        
    }
    
    
}