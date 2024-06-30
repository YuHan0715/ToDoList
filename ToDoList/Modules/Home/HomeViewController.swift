
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
        cvCategory.register(TaskCategoryCollectionViewCell.loadFromNib(), forCellWithReuseIdentifier: kTaskCategoryCollectionViewCellID)
        
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
        
        viewModel.$aryTaskCategoryViewModel
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
            })
            .store(in: &aryBindings)
    }
    
    private func showPicker(_ pickerViewModel: PickerViewModel) {
        navigator.show(segue: .picker(viewModel: pickerViewModel), sender: self, transition: .alert)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.aryTaskCategoryViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTaskCategoryCollectionViewCellID, for: indexPath) as? TaskCategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.binding(viewModel.aryTaskCategoryViewModel[indexPath.row])
        
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
