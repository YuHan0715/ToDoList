//
//  GetOption.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/28.
//

import Foundation

struct GetOptionRequest: Encodable {
    
}


struct GetOptionResponse: Decodable {
    let categories: [CategoryInfo]
    
    let filterOptions: [FilterOptionInfo]
}

struct CategoryInfo: Decodable {
    let categoryName: String
    
    let categoryCode: String
}

struct FilterOptionInfo: Decodable {
    let optionsName: String
    
    let optionCode: String
}
