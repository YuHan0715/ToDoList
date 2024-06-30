//
//  Blund+Extension.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/26.
//

import Foundation

extension Bundle {
    func url(forJsonResource name: String?) -> URL? {
        return url(forResource: name, withExtension: "json")
    }
    
    func data(forJsonResource name: String?) -> Data? {
        return self.url(forJsonResource: name)?.getContentData()
    }
}
