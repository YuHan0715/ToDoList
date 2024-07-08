
import Foundation
import Combine

enum FilterOptionType: String, CaseIterable {
    case Completed = "Completed"
    case Overdue = "Overdue"
    case Priority = "High Priority"
}

enum SortOptionType: String, CaseIterable {
    case DueDate = "Due Date"
    case priority = "Priority"
    case CreationDate = "Creation Date"
}

class HomeViewModel: BaseViewModel {
    @Published var aryTaskFilterViewModel: [TaskFilterCollectionViewCellViewModel] = []
    @Published var aryDisplayTask: [ToDoListTableViewCellViewModel] = []
    @Published var selectedCategory: CategoryInfo?
    @Published var selectedSort: SortOptionType?
    @Published var arySelectedFilter: [FilterOptionType] = []
    var strSearchWord: String = ""
    var aryCategoryOptions: [CategoryInfo] = []
    var aryAllTasks: [TaskInfo] = []
    var sortPickerViewModel: PickerViewModel?
    var categoryPickerViewModel: PickerViewModel?
    
    var updateSuccess = PassthroughSubject<Void, Never>()
    
    var aryBindings = Set<AnyCancellable>()
    
    
    // MARK: - init
    override init(provider: YuHanAPI) {
        super.init(provider: provider)
        self.createTaskFilterViewModel()
        self.createSortPickerModel()
    }
    
    // MARK: Public Func
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
                aryAllTasks = getTaskListRespsone.tasks
                aryDisplayTask = createToDoTaskModel(taskInfos: aryAllTasks)
            }))
    }
    
    func updateTask(_ info: TaskInfo) {
        let req = UpdateTaskRequest(task: info)
        provider.updateTask(request: req)
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
            }, receiveValue: { [unowned self] getTaskListRespsone in
                guard let getTaskListRespsone = getTaskListRespsone else { return }
                updateSuccess.send(())
                aryDisplayTask = createToDoTaskModel(taskInfos: aryAllTasks)
                
            }))
    }
    
    func updateDisplayToDoList () {
        switchCategory()
        filterOption()
        filterListTitle()
    }
    
    func sortToDoList(_ type: SortOptionType) {
        switch type {
        case .CreationDate:
            aryDisplayTask.sort(by: { (lhs, rhs) in
                guard let lhsCreatTime = lhs.taskInfo.createTime.strDateToDate(format: .apiResponseDate),
                      let rhsCreaTime = rhs.taskInfo.createTime.strDateToDate(format: .apiResponseDate) else { return false }
                return lhsCreatTime < rhsCreaTime
            })
        case .DueDate:
            aryDisplayTask.sort(by: { (lhs, rhs) in
                guard let lhsDueDate = lhs.taskInfo.dueDate.strDateToDate(format: .apiResponseDate),
                      let rhsDueDate = rhs.taskInfo.dueDate.strDateToDate(format: .apiResponseDate) else {
                    return false }
                return lhsDueDate < rhsDueDate
            })
        case .priority: 
            aryDisplayTask.sort(by: { $0.taskInfo.priority.rawValue < $1.taskInfo.priority.rawValue })
        }
    }
    
    func deleteDisplayTask(task: TaskInfo?) {
        if let index = aryAllTasks.firstIndex(where: { $0.taskId == task?.taskId }) {
            aryAllTasks[index].status = .Delete
            updateTask(aryAllTasks[index])
        }
    }
    
    func setRepeat(task: TaskInfo, repeatDay: Int) {
        if let index = aryAllTasks.firstIndex(where: { $0.taskId == task.taskId }) {
            aryAllTasks[index].isRepeat = true
            aryAllTasks[index].repeatTime = repeatDay
            updateTask(aryAllTasks[index])
        }
    }
    
    func filterListTitle() {
        guard !strSearchWord.isEmpty else { return }
        aryDisplayTask = aryDisplayTask.filter({ $0.taskInfo.title.lowercased().contains(strSearchWord.lowercased()) })
    }
    
    // MARK: Private Func
    private func switchCategory() {
        guard let selectedCategory = selectedCategory else { return }
        if (selectedCategory.categoryCode == "000") {
            aryDisplayTask = createToDoTaskModel(taskInfos: aryAllTasks)
        } else {
            aryDisplayTask = createToDoTaskModel(taskInfos: aryAllTasks.filter({ $0.category == selectedCategory.categoryCode }) )
        }
    }
    
    private func filterOption() {
        arySelectedFilter.forEach({ [unowned self] selectedType in
            switch selectedType {
            case .Completed:
                aryDisplayTask = aryDisplayTask.filter({ $0.taskInfo.status == .Done })
            case .Overdue:
                aryDisplayTask = aryDisplayTask.filter({ viewModel in
                    guard let dueDate =  viewModel.taskInfo.dueDate.strDateToDate(format: .apiResponseDate) else { return false }
                    return dueDate.compare(Date()) == .orderedAscending
                })
            case .Priority:
                aryDisplayTask = aryDisplayTask.filter({ $0.taskInfo.priority == .High })
            }
        })
    }
    
    private func createCategoryPickerModel() {
        selectedCategory = aryCategoryOptions.first
        categoryPickerViewModel = PickerViewModel(provider: provider, options: aryCategoryOptions.map({ $0.categoryName }))
        categoryPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedCategory = aryCategoryOptions.first(where: { $0.categoryName == selectedTitle })
            })
            .store(in: &aryBindings)
    }
    
    private func createSortPickerModel() {
        sortPickerViewModel = PickerViewModel(provider: provider, options: SortOptionType.allCases.map({ $0.rawValue }))
        sortPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedSort = SortOptionType(rawValue: selectedTitle)
            })
            .store(in: &aryBindings)
    }
    
    private func createToDoTaskModel(taskInfos: [TaskInfo]) -> [ToDoListTableViewCellViewModel] {
        return taskInfos.filter({ $0.status != .Delete }).map({ [unowned self] info in
            let taskViewModel = ToDoListTableViewCellViewModel(taskInfo: info)
            
            taskViewModel.clickCheckButton
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [unowned self] in
                    updateTask(taskViewModel.taskInfo)
                })
                .store(in: &aryBindings)
            return taskViewModel
        })
    }
    
    private func createTaskFilterViewModel() {
        aryTaskFilterViewModel = FilterOptionType.allCases.map({ type in
            let taskFilterViewModel = TaskFilterCollectionViewCellViewModel(type: type)
            taskFilterViewModel.$bDidSelected
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [unowned self] didSelected in
                    if (didSelected) {
                        arySelectedFilter.append(taskFilterViewModel.type)
                    } else {
                        arySelectedFilter = arySelectedFilter.filter{ $0 != type }
                    }
                })
                .store(in: &aryBindings)
            return taskFilterViewModel
        })
    }
}
