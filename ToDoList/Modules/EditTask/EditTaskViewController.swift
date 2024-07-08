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
        
        lbTaskCategory.text = i18n.Edit.Category
        lbTaskSelectCategory.text = i18n.Edit.Category_Placeholder
        
        lbTaskPriority.text = i18n.Edit.Priority
        lbTaskSelectPriority.text = i18n.Edit.Priority_Placeholder
    
        lbSubTask.text = i18n.Edit.SubTask
        lbSelectSubTask.text = i18n.Edit.SubTask_Placeholder
        
        lbTaskDescription.text = i18n.Edit.Description
        txvTaskDescription.text = i18n.Edit.Description_Placeholder
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }

}
