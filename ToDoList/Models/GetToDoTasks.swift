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

struct TaskInfo: Decodable, Encodable {
    let taskId: String
    
    let title: String
    
    let description: String?
    
    let dueDate: String
    
    let createTime: String
    
    let priority: TaskPriority
    
    let category: String
    
    var status: TaskStatus
    
    var isRepeat: Bool
    
    var repeatTime: Int?
    
    let subtasks: [String]
}

enum TaskPriority: String, Codable, CaseIterable {
    case High = "0"
    
    case Medium = "1"
    
    case Low = "2"
    
    var title: String {
        switch self {
        case .High:
            return i18n.Task.Priority_Hight
        case .Medium:
            return i18n.Task.Priority_Mid
        case .Low:
            return i18n.Task.Priority_Low
        }
    }
}

enum TaskStatus: String, Codable {
    case NotStart = "0"
    
//    case InProgress = "1"
    
    case Done = "2"
    
    case Delete = "3"
}
