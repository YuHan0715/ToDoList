//
//  UIColor+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/29.
//

import UIKit

extension UIColor {
    public class func regular(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let regularMax = 255.0
        return UIColor.init(red: red / regularMax, green: green / regularMax, blue: blue / regularMax, alpha: alpha)
    }
    
    public class var highPriorityColor: UIColor {
        return UIColor.regular(red: 255, green: 76, blue: 76, alpha: 1.0)
    }
    
    public class var MedPriorityColor: UIColor {
        return UIColor.regular(red: 52, green: 191, blue: 73, alpha: 1.0)
    }
    
    public class var LowPriorityColor: UIColor {
        return UIColor.regular(red: 0, green: 153, blue: 229, alpha: 1.0)
    }
}
