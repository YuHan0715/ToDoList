//
//  PickerViewModel.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/29.
//

import Foundation
import Combine

class PickerViewModel: BaseViewModel {
    var aryOptions: [String]
    var iSelectedIndex: Int
    @Published var didSelectedItem = PassthroughSubject<(String, Int), Never>()
    
    init(provider: YuHanAPI, options: [String], currentSelected: Int = 0) {
        self.aryOptions = options
        self.iSelectedIndex = currentSelected
        super.init(provider: provider)
    }
}
