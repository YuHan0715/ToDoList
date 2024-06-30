//
//  UIView+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/25.
//

import Foundation
import UIKit

extension UIView {
    class func initFromNib() -> Self {
        return initFromNib(self)
    }
    
    private class func initFromNib<T: UIView>(_ type: T.Type) -> T {
        let objects = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: [:])
        return objects?.first as? T ?? T()
    }
    
    public class func loadFromNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public func addCornerRadius(_ radius: CGFloat = 8.0) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func addBoder(_ color: UIColor = UIColor.lightGray, _ width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
