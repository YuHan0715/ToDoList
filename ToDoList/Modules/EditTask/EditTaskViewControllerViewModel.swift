//
//  EditTaskViewControllerViewModel.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/8.
//

import Foundation
import Combine

enum TaskEditType {
    case Edit
    case Create
}

class EditTaskViewControllerViewModel: BaseViewModel {
    @Published var selectedCategory: CategoryInfo?
    @Published var selectedPriority: TaskPriority?
    @Published var selectedSubTask: TaskInfo?
    var type: TaskEditType
    var taskInfo: TaskInfo?
    
    var aryCategoryOptions: [CategoryInfo] = []
    var aryTaskPriorityOptions: [TaskPriority] = TaskPriority.allCases
    var aryAllTasks: [TaskInfo] = []
    var categoryPickerViewModel: PickerViewModel?
    var priorityPickerViewModel: PickerViewModel?
    var subTaskPickerViewModel: PickerViewModel?
    
    var aryBindings = Set<AnyCancellable>()
    
    init(provider: YuHanAPI, type: TaskEditType, taskInfo: TaskInfo? = nil) {
        self.type = type
        self.taskInfo = taskInfo
        super.init(provider: provider)
        createCategoryPickerModel()
        creatPriorityPickerModel()
    }
    
    func getListProcess() {
        Publishers
            .Zip(
                provider.getOption(request: GetOptionRequest()),
                provider.getToDoLists(request: GetToDoTasksRequest())
            )
            .handleEvents(receiveSubscription: { [unowned self] _ in
                isLoading = true
            }, receiveOutput: { [unowned self] _ in
                isLoading = false
            }, receiveCompletion: { [unowned self] _ in
                isLoading = false
            }, receiveCancel: { [unowned self] in
                isLoading = false
            })
            .subscribe(Subscribers.Sink(receiveCompletion: { [unowned self] completion in
                guard case let .failure(error) = completion else { return }
                errorOccurredShowAlert.send(error)
            }, receiveValue: { [unowned self] (getOptionsResponse, getTaskListRespsone) in
                guard let getOptionsResponse = getOptionsResponse,
                      let getTaskListRespsone = getTaskListRespsone else { return }
                aryCategoryOptions = getOptionsResponse.categories
                createCategoryPickerModel()
                aryAllTasks = getTaskListRespsone.tasks.filter({ $0.taskId != taskInfo?.taskId })
                createSubTaskPickerModel()
                initValue()
            }))
    }
    
    private func createCategoryPickerModel() {
        categoryPickerViewModel = PickerViewModel(provider: provider, options: aryCategoryOptions.map({ $0.categoryName }))
        categoryPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedCategory = aryCategoryOptions.first(where: { $0.categoryName == selectedTitle })
            })
            .store(in: &aryBindings)
    }
    
    private func creatPriorityPickerModel() {
        priorityPickerViewModel = PickerViewModel(provider: provider, options: aryTaskPriorityOptions.map({ $0.title }))
        priorityPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedPriority = aryTaskPriorityOptions.first(where: { $0.title == selectedTitle })
            })
            .store(in: &aryBindings)
    }
    
    private func createSubTaskPickerModel() {
        subTaskPickerViewModel = PickerViewModel(provider: provider, options: aryAllTasks.map({ $0.title }))
        subTaskPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedSubTask = aryAllTasks.first(where: { $0.title == selectedTitle })
            })
            .store(in: &aryBindings)
    }
    
    private func initValue() {
        selectedCategory = aryCategoryOptions.first(where: { $0.categoryCode == taskInfo?.category })
        selectedPriority = aryTaskPriorityOptions.first(where: { $0 == taskInfo?.priority })
        selectedSubTask = aryAllTasks.first(where: { $0.taskId == taskInfo?.subtasks.first })
    }
}
