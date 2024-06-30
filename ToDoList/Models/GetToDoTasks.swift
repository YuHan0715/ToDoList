//
//  GetToDoTasks.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/28.
//

import Foundation

struct GetToDoTasksRequest: Encodable {

}

struct GetToDoTasksResponse: Decodable {
    let tasks: [TaskInfo]
}

struct TaskInfo: Decodable {
    let taskId: String
    
    let title: String
    
    let description: String?
    
    let dueDate: String
    
    let createTime: String
    
    let priority: TaskPriority
    
    let category: String
    
    let status: TaskStatus
    
    let isRepeat: Bool
    
    let repeatTime: Int?
    
    let subtasks: [String]
}

enum TaskPriority: String, Codable {
    case High = "0"
    
    case Medium = "1"
    
    case Low = "2"
}

enum TaskStatus: String, Codable {
    case NotStart = "0"
    
//    case InProgress = "1"
    
    case Done = "2"
}
