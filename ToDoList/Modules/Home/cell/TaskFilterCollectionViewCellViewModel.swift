//
//  TaskFilterCollectionViewCellViewModel.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/27.
//

import Foundation
import Combine

let kTaskFilterCollectionViewCellID = "TaskFilterCollectionViewCellID"

class TaskFilterCollectionViewCellViewModel {
    @Published var bDidSelected: Bool = false
    var type: FilterOptionType
    
    init(type: FilterOptionType) {
        self.type = type
    }
    
    func switchSelected() {
        bDidSelected = !bDidSelected
    }
}
