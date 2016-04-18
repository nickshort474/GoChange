//
//  GoChangeClient.swift
//  GoChange
//
//  Created by Nick Short on 17/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class GoChangeClient:NSObject{
    
       
    
    
    class func sharedInstance() -> GoChangeClient{
    
        struct Singleton{
            static var sharedInstance = GoChangeClient()
        }
        return Singleton.sharedInstance
    }
    
}
