//
//  Login.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/26.
//

import Foundation

struct LoginRequest: Encodable {
    let account: String
    let pwd: String
}

struct LoginResponse: Decodable {
    let token: String
}
