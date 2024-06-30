
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
    @Published var aryTaskListViewModel: [ToDoListTableViewCellViewModel] = []
    @Published var aryDisplayTask: [ToDoListTableViewCellViewModel] = []
    @Published var selectedCategory: CategoryInfo?
    @Published var selectedSort: SortOptionType?
    @Published var arySelectedFilter: [FilterOptionType] = []
    var aryCategoryOptions: [CategoryInfo] = []
    var aryAllTasks: [TaskInfo] = []
    var sortPickerViewModel: PickerViewModel?
    var categoryPickerViewModel: PickerViewModel?
    
    var aryBindings = Set<AnyCancellable>()
    
    override init(provider: YuHanAPI) {
        sortPickerViewModel = PickerViewModel(provider: provider, options: SortOptionType.allCases.map({ $0.rawValue }))
        super.init(provider: provider)
        self.createTaskFilterViewModel()
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
                aryAllTasks = getTaskListRespsone.tasks
                createToDoTaskModel()
            }))
    }
    
    func updateDisplayToDoList () {
        switchCategory()
        filterOption()
    }
    
    private func switchCategory() {
        guard let selectedCategory = selectedCategory else { return }
        if (selectedCategory.categoryCode == "000") {
            aryDisplayTask = aryAllTasks.map({ ToDoListTableViewCellViewModel(taskInfo: $0) })
        } else {
            aryDisplayTask = aryAllTasks.filter({ $0.category == selectedCategory.categoryCode }).map({ ToDoListTableViewCellViewModel(taskInfo: $0) })
        }
    }
    
    private func filterOption() {
        arySelectedFilter.forEach({ [unowned self] selectedType in
            switch selectedType {
            case .Completed:
                aryDisplayTask = aryDisplayTask.filter({ $0.taskInfo.status == .Done })
            case .Overdue:
//                aryDisplayTask = ary
                aryDisplayTask = aryDisplayTask
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
    
    private func createSortPickerMode() {
        sortPickerViewModel = PickerViewModel(provider: provider, options: SortOptionType.allCases.map({ $0.rawValue }))
        sortPickerViewModel?.didSelectedItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] (selectedTitle, selectedIndex) in
                selectedSort = SortOptionType(rawValue: selectedTitle)
            })
            .store(in: &aryBindings)
    }
    
    private func createToDoTaskModel() {
        aryDisplayTask = aryAllTasks.map({ ToDoListTableViewCellViewModel(taskInfo: $0) })
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
