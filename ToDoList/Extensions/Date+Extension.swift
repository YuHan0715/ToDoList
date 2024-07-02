//
//  Date+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/2.
//

import Foundation

extension Date {
    
    func iso8601dateToString(format: DateFormat) -> String {
        let dateManager = DateManager.iso8601DateFormatter
        dateManager.dateFormat = format.rawValue
        return dateManager.string(from: self)
    }
    
}
