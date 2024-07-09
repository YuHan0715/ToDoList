//
//  EditTaskViewController.swift
//  ToDoList
//
//  Created by yuhan on 2024/7/8.
//

import UIKit
import Combine

class EditTaskViewController: BaseViewModelController<EditTaskViewControllerViewModel> {
    
    @IBOutlet weak var lbTaskTitle: UILabel!
    @IBOutlet weak var tfTaskTitle: UITextField!
    @IBOutlet weak var lbTaskDueDate: UILabel!
    @IBOutlet weak var lbTaskSelectDueDate: UILabel!
    @IBOutlet weak var btnTaskDueDate: UIButton!
    @IBOutlet weak var lbTaskCategory: UILabel!
    @IBOutlet weak var lbTaskSelectCategory: UILabel!
    @IBOutlet weak var btnTaskCategory: UIButton!
    @IBOutlet weak var lbTaskPriority: UILabel!
    @IBOutlet weak var lbTaskSelectPriority: UILabel!
    @IBOutlet weak var btnTaskPriority: UIButton!
    @IBOutlet weak var lbTaskDescription: UILabel!
    @IBOutlet weak var lbSubTask: UILabel!
    @IBOutlet weak var lbSelectSubTask: UILabel!
    @IBOutlet weak var btnSubTask: UIButton!
    @IBOutlet weak var txvTaskDescription: UITextView!
    
    var aryBindings = Set<AnyCancellable>()

    override func initView() {
        super.initView()
        
        lbTaskTitle.text = i18n.Edit.Title
        tfTaskTitle.placeholder = i18n.Edit.Title_Placeholder
        
        lbTaskDueDate.text = i18n.Edit.DueDate
        lbTaskSelectDueDate.text = i18n.Edit.DueDate_Placeholder
        lbTaskSelectDueDate.setPlaceholderStyle()
        
        lbTaskCategory.text = i18n.Edit.Category
        lbTaskSelectCategory.text = i18n.Edit.Category_Placeholder
        lbTaskSelectCategory.setPlaceholderStyle()
        
        lbTaskPriority.text = i18n.Edit.Priority
        lbTaskSelectPriority.text = i18n.Edit.Priority_Placeholder
        lbTaskSelectPriority.setPlaceholderStyle()
    
        lbSubTask.text = i18n.Edit.SubTask
        lbSelectSubTask.text = i18n.Edit.SubTask_Placeholder
        lbSelectSubTask.setPlaceholderStyle()
        
        lbTaskDescription.text = i18n.Edit.Description
        txvTaskDescription.text = i18n.Edit.Description_Placeholder
        txvTaskDescription.setPlaceholderStyle()
        
        txvTaskDescription.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getListProcess()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        btnTaskCategory.publisher(for: .touchUpInside)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [unowned self] in
            guard let pickerViewModel = viewModel.categoryPickerViewModel else { return } // TODO: Show aler to description category optsions is empty
            showPicker(pickerViewModel)
        })
        .store(in: &aryBindings)
        
        btnTaskPriority.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                guard let pickerViewModel = viewModel.priorityPickerViewModel else { return } // TODO: show aler to description priority options is empty
                showPicker(pickerViewModel)
            })
            .store(in: &aryBindings)
        
        btnSubTask.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                guard let pickerViewModel = viewModel.subTaskPickerViewModel else { return } // TODO: show alert to description sub task is empty
                showPicker(pickerViewModel)
            })
            .store(in: &aryBindings)
        
        tfTaskTitle.textPublisher
            .receive(on: DispatchQueue.main)
            .filter({ $0?.isEmpty != false })
            .assign(to: \.strTaskTitle, on: viewModel)
            .store(in: &aryBindings)
        
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] selectedCategory in
                guard let selectedCategory = selectedCategory, !selectedCategory.categoryName.isEmpty else { return }
                lbTaskSelectCategory.text = selectedCategory.categoryName
                lbTaskSelectCategory.setNomalStyle()
            })
            .store(in: &aryBindings)
        
        viewModel.$selectedPriority
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] selectedPriority in
                guard let selectedPriority = selectedPriority else { return }
                lbTaskSelectPriority.text = selectedPriority.title
                lbTaskSelectPriority.setNomalStyle()
            })
            .store(in: &aryBindings)
        
        viewModel.$selectedSubTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] selectedSubTask in
                guard let selectedSubTask = selectedSubTask else { return }
                lbSelectSubTask.text = selectedSubTask.title
                lbSelectSubTask.setNomalStyle()
            })
            .store(in: &aryBindings)
        
        viewModel.$selectedDueDate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] selectedDueDate in
                guard let selectedDueDate = selectedDueDate else { return }
                lbTaskSelectDueDate.text = selectedDueDate
                lbTaskSelectDueDate.setNomalStyle()
            })
            .store(in: &aryBindings)
        
        viewModel.canInitView
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                tfTaskTitle.text = viewModel.taskInfo?.title
                guard let taskDescription = viewModel.strTaskDescription else { return }
                txvTaskDescription.text = taskDescription
                txvTaskDescription.setNomalStyle()
            })
            .store(in: &aryBindings)
    }
    
    private func showPicker(_ pickerViewModel: PickerViewModel) {
        navigator.show(segue: .picker(viewModel: pickerViewModel), sender: self, transition: .alert)
    }
}


extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.strTaskDescription = textView.text
    }
}
