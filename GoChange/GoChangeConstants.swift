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
        
        static var requestIDURL = "https://api.change.org/v1/petitions/get_id"
        static var requestPetitionInfoURL = "https://api.change.org/v1/petitions/"        
        
        static var basePetitionURL = "https://www.change.org/"
        
        static var dynamicPetitionURL = ""
        
        static var detailText:String = "Please enter details of the problem you want solving..."
        
        static let blueFloat:CGFloat = 1/255 * 25
        static let redFloat:CGFloat = 1/255 * 253
        static let greenFloat:CGFloat = 1/255 * 153
        
        static let customOrangeColor:UIColor = UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: 1.0)
        
        
    }
    
    
}