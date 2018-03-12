//
//  Extensions.swift
//  ExtensionToolkit
//
//  Created by Trainee on 12/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import UIKit

public extension Int {
    
    /*
     Attempts to parse a string with the format HH:mm:ss and return an Int with the total amount of seconds
     
     - parameter hms: A string with the format HH:mm:ss
     - returns: An Int
     */
    public static func parseHMS(hms: String) -> Int {
        let parts = hms.split(separator: ":")
        
        var hours = Int(parts[0]) ?? 0
        var minutes = Int(parts[1]) ?? 0
        let seconds = Int(parts[2]) ?? 0
        
        hours = hours * 3600
        minutes = minutes * 60
        
        return hours + minutes + seconds
    }
}

public extension CGFloat {
    /*
     Attempts to parse a string with the format HH:mm:ss and return a CGFloat with the total amount of seconds
     
     - parameter hms: A string with the format HH:mm:ss
     - returns: A CGFloat
     */
    public static func parseHMS(hms: String) -> CGFloat {
        return CGFloat(Int.parseHMS(hms: hms))
    }
}
