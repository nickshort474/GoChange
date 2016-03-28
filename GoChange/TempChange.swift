//
//  TempChange.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class TempChange:NSObject{
    
    
    var changeName:String = ""
    var changeDetail:String = ""
    
    
    var solutionNameArray:NSMutableArray = []
    var solutionDetailArray:NSMutableArray = []
    
    
    //var solutionDictionary:Dictionary = [String:AnyObject]()
    
    var tweakNameArray:NSMutableArray = []
    var tweakDetailArray:NSMutableArray = []
    
    
    
    
    class func sharedInstance() -> TempChange{
        
        struct Static{
            static let instance = TempChange()
        }
        
        return Static.instance
    }
    
    
}