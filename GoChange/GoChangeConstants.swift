//
//  GoChangeConstants.swift
//  GoChange
//
//  Created by Nick Short on 17/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit


extension GoChangeClient{
    
    struct Constants{
        
        static var userID:String = ""
        static var userName:String = ""
        static var apiKey = "1a4f569e8857b5ce19ed32d20b799f1e8d922b8b3bd5413cbaa8fb9c2664ad41"
        
        static var requestURL = "https://api.change.org/v1/petitions/get_id"
        
        static var basePetitionURL = "http://www.change.org/"
        
        static var dynamicPetitionURL = ""
        
        static var detailText:String = "Please enter details of the change you would like to see..."
    }
    
    
}