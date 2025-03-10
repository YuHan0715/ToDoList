//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/27.
//

import UIKit
import Combine

class ToDoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet weak var btnIsCompelete: UIButton!
    @IBOutlet weak var vBackground: UIView!
    
    var aryBindings = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        vBackground.addCornerRadius()
        btnIsCompelete.setImage(.checked, for: .selected)
        btnIsCompelete.setImage(.unchecked, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aryBindings.removeAll()
    }
    
    func binding(_ viewModel: ToDoListTableViewCellViewModel) {
        viewModel.$taskInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] info in
                lbTitle.text = info.title
                lbDueDate.text = info.dueDate.strDateFormatConverter(.apiResponseDate, .dashDate)
                switch info.priority {
                case .High:
                    vBackground.backgroundColor = UIColor.highPriorityColor
                case .Medium:
                    vBackground.backgroundColor = UIColor.MedPriorityColor
                case .Low:
                    vBackground.backgroundColor = UIColor.LowPriorityColor
                }
                btnIsCompelete.isSelected = info.status == .Done
            })
            .store(in: &aryBindings)
        
        btnIsCompelete.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                viewModel.taskInfo.status = !btnIsCompelete.isSelected ? .Done : .NotStart
                viewModel.clickCheckButton.send()
            })
            .store(in: &aryBindings)
    }
    
}
