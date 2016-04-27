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
    var changeOwner:String = ""
    var changeDetail:String = ""
    
    
    var solutionNameArray:NSMutableArray = []
    var solutionDetailArray:NSMutableArray = []
    var solutionVoteArray:NSMutableArray = []
    
    
    //var solutionNewOldArray:NSMutableArray = []
    
    var solutionIDArray:NSMutableArray = []
    
    var solutionOwnerArray:NSMutableArray = []
    
    var newSolutionIDArray:NSMutableArray = []
    var newSolutionNameArray:NSMutableArray = []
    var newSolutionDetailArray:NSMutableArray = []
    var newSolutionVoteArray:NSMutableArray = []
    
    var tweakNameArray:NSMutableArray = []
    var tweakDetailArray:NSMutableArray = []
    
    //var addingSolutions:String = ""
    
    
    
    
    
    class func sharedInstance() -> TempChange{
        
        struct Static{
            static let instance = TempChange()
        }
        
        return Static.instance
    }
    
    
}