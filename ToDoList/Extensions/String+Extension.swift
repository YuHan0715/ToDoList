//
//  String+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/2.
//

import Foundation

extension String {
    
    func strDateToDate(format: DateFormat) -> Date? {
        let dateManger = DateManager.generalDateFormatter
        dateManger.dateFormat = format.rawValue
        return dateManger.date(from: self)
    }
    
    func iso8601stringToDate(format: DateFormat) -> Date? {
        let dateManger = DateManager.iso8601DateFormatter
        dateManger.dateFormat = format.rawValue
        return dateManger.date(from: self)
    }
    
    func strDateFormatConverter(_ inputFormat: DateFormat, _ outputFormet: DateFormat) -> String {
        if var date = self.iso8601stringToDate(format: inputFormat) {
            return date.iso8601dateToString(format: outputFormet)
        }
        
        return ""
    }
}
