//
//  Extensions.swift
//  ExtensionToolkit
//
//  Created by Trainee on 12/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import UIKit
import CoreData

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

public enum Fill {
    case dotted
    case line
    case space
}

public extension UILabel {
    
    public func fillRemaining(_ fill: Fill, offset: CGFloat = 16) {
        
        guard let attributedText = self.attributedText else {
            var string = NSString(string: self.text!)
            var textSize: CGSize = string.size(withAttributes: [NSAttributedStringKey.font: self.font])
            
            while (textSize.width < self.bounds.width - offset) {
                self.text = self.text! + stringForFill(fill)
                
                string = NSString(string: self.text!)
                textSize = string.size(withAttributes: [NSAttributedStringKey.font: self.font])
            }
            return
        }
        
        let textSize: CGSize = attributedText.size()
        let font = UIFont(name: "AvenirNext-Regular", size: self.font.pointSize) ?? UIFont.systemFont(ofSize: self.font.pointSize)
        let fillString: NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: font])
        
        while (textSize.width + fillString.size().width < self.bounds.width - offset) {
            let filler = NSAttributedString(string: stringForFill(fill), attributes: [NSAttributedStringKey.font: font])
            fillString.append(filler)
        }
        self.attributedText! = NSMutableAttributedString(attributedString: self.attributedText!).appending(fillString)
    }
    
    fileprivate func stringForFill(_ fill: Fill) -> String {
        
        if fill == .dotted {
            return "."
        }
        
        if fill == .line {
            return "_"
        }
        
        return " "
    }
}

public extension NSMutableAttributedString {
    
    //Appends a NSAttributedString to a new instance of the NSMutableAttributedString and returns the new instance
    public func appending(_ string: NSAttributedString) -> NSMutableAttributedString {
        let l = NSMutableAttributedString(attributedString: self)
        l.append(string)
        return l
    }
}
