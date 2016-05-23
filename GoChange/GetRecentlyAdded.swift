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
    
    
    
    
    init(completionHandler:(result:AnyObject)->Void){
        super.init()
        
        
        let ref = FIRDatabase.database().reference().child("problem/RecentlyAdded")
        
        ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            
            completionHandler(result: snapshot)
            
        }, withCancelBlock:{error in
            
            print(error.description)
            
        })
        
        
        
        
    }
    
    
    
}