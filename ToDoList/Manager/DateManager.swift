//
//  DateManager.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/2.
//

import Foundation

enum DateFormat: String {
    case dashWithmillisecond = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case apiResponseDate = "yyyy-MM-dd HH:mm:ss"
    case slashDate = "yyyy/MM/dd"
    case dashDate = "yyyy-MM-dd"
}

class DateManager {

    static let iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8*60*60)
    
        return dateFormatter
    }()
    
    static let generalDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter
    }()
}
