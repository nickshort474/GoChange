//
//  GetRecentlyAdded.swift
//  GoChange
//
//  Created by Nick Short on 10/05/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase

class GetRecentlyAdded:NSObject{
    
    
    var ref = Firebase(url: "https://gochange.firebaseio.com/problem/RecentlyAdded")
    
    init(completionHandler:(result:FDataSnapshot)->Void){
        super.init()
        
        
        ref.observeEventType(.Value, withBlock: {snapshot in
            
            
            completionHandler(result: snapshot)
            
        }, withCancelBlock:{error in
            
            print(error.description)
            
        })
        
        
        
        
    }
    
    
    
}