//
//  UILabel+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/9.
//

import Foundation
import UIKit

extension UILabel {
    
    func setPlaceholderStyle() {
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }
    
    func setNomalStyle() {
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
}
