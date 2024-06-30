//
//  URL+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/26.
//

import Foundation

extension URL {
    func getContentData() -> Data? {
        return try? Data(contentsOf: self)
    }
}
