//
//  ToDoListTableViewCellViewModel.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/27.
//

import Foundation
import Combine

let kToDoListTableViewCellID = "ToDoListTableViewCellID"

class ToDoListTableViewCellViewModel {
    @Published var taskInfo: TaskInfo
    @Published var clickCheckButton = PassthroughSubject<Void, Never>()
    
    init(taskInfo: TaskInfo) {
        self.taskInfo = taskInfo
    }
}
