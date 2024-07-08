
import UIKit
import Combine

class HomeViewController: BaseViewModelController<HomeViewModel> {
    @IBOutlet weak var btnPersonalProfile: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSortOption: UIButton!
    @IBOutlet weak var btnAddList: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var tvToDoLists: UITableView!
    
    var aryBindings = Set<AnyCancellable>()
    
    override func initView() {
        super.initView()
        
        tvToDoLists.register(ToDoListTableViewCell.loadFromNib(), forCellReuseIdentifier: kToDoListTableViewCellID)
        cvCategory.register(TaskFilterCollectionViewCell.loadFromNib(), forCellWithReuseIdentifier: kTaskFilterCollectionViewCellID)
        tfSearch.placeholder = i18n.Home.Search_Placeholder
        
        viewModel.getListProcess()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        btnSortOption.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                guard let pickerViewModel = viewModel.sortPickerViewModel else { return } // TODO: Show aler to description sort is empty
                showPicker(pickerViewModel)
            })
            .store(in: &aryBindings)
        btnCategory.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                guard let pickerViewModel = viewModel.categoryPickerViewModel else { return } // TODO: Show aler to description category is empty
                showPicker(pickerViewModel)
            })
            .store(in: &aryBindings)
        tfSearch.textPublisher
            .receive(on: DispatchQueue.main)
            .replaceNil(with: "")
            .sink(receiveValue: { [unowned self] searchWord in
                viewModel.strSearchWord = searchWord
                viewModel.updateDisplayToDoList()
            })
            .store(in: &aryBindings)
        
        viewModel.$aryTaskFilterViewModel
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.cvCategory.reloadData()
            })
            .store(in: &aryBindings)
        
        viewModel.$aryDisplayTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tvToDoLists.reloadData()
            })
            .store(in: &aryBindings)
        
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] seletedCatagory in
                btnCategory.setTitle(seletedCatagory?.categoryName, for: .normal)
                viewModel.updateDisplayToDoList()
            })
            .store(in: &aryBindings)
        
        viewModel.$arySelectedFilter
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] arySelected in
                viewModel.updateDisplayToDoList()
            })
            .store(in: &aryBindings)
        
        viewModel.$selectedSort
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] sortOption in
                guard let sortOption = sortOption else { return }
                viewModel.sortToDoList(sortOption)
            })
            .store(in: &aryBindings)
        
        viewModel.updateSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                changeNextAction(segue: .alert(description: "更新成功"), transition: .alert)
            })
            .store(in: &aryBindings)
    }
    
    private func showEditTask() {
        let editTaskViewModel = EditTaskViewControllerViewModel(provider: viewModel.provider)
        navigator.show(segue: .editTask(viewModel: editTaskViewModel), sender: self)
    }
    
    private func showPicker(_ pickerViewModel: PickerViewModel) {
        navigator.show(segue: .picker(viewModel: pickerViewModel), sender: self, transition: .alert)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("-----didSelectRowAt-----")
        showEditTask()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.aryDisplayTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kToDoListTableViewCellID, for: indexPath) as? ToDoListTableViewCell else { return UITableViewCell() }
        cell.binding(viewModel.aryDisplayTask[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, completionHandler) in
            self?.viewModel.deleteDisplayTask(task: self?.viewModel.aryDisplayTask[indexPath.row].taskInfo)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "edit") { (action, view, completionHandler) in
            self.showEditTask()
            completionHandler(true)
        }
        editAction.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = viewModel.aryDisplayTask[indexPath.row].taskInfo
        let repeatEveryDay = UIContextualAction(style: .normal, title: "EveryDay") { [weak self] (action, view, completionHandler) in
            self?.viewModel.setRepeat(task: task, repeatDay: 1)
            completionHandler(true)
        }
        
        let repeatEveryWeek = UIContextualAction(style: .normal, title: "EveryWeek") { [weak self] (action, view, completionHandler) in
            self?.viewModel.setRepeat(task: task, repeatDay: 7)
            completionHandler(true)
        }
        
        let repeatEveryMon = UIContextualAction(style: .normal, title: "EveryMonth") { [weak self] (action, view, completionHandler) in
            self?.viewModel.setRepeat(task: task, repeatDay: 30)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [repeatEveryDay, repeatEveryWeek, repeatEveryMon])
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.aryTaskFilterViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTaskFilterCollectionViewCellID, for: indexPath) as? TaskFilterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.binding(viewModel.aryTaskFilterViewModel[indexPath.row])
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSizeHeight = collectionView.bounds.size.height
        let size = CGSize(width: cellSizeHeight * 3, height: cellSizeHeight)
        return size
    }
}
