//
//  TaskCategoryCollectionViewCell.swift
//  Task
//
//  Created by yuhan on 2024/6/27.
//

import UIKit
import Combine

class TaskCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCategory: UIButton!
    
    var aryBindings = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()

        btnCategory.addBoder()
        btnCategory.setTitleColor(.lightGray, for: .normal)
        btnCategory.setTitleColor(.white, for: .selected)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        btnCategory.addCornerRadius(btnCategory.bounds.height / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        aryBindings.removeAll()
    }
    
    func binding(_ viewModel: TaskCategoryCollectionViewCellViewModel) {
        btnCategory.setTitle(viewModel.type.rawValue, for: .normal)
        btnCategory.sizeToFit()
        
        btnCategory.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                viewModel.switchSelected()
            })
            .store(in: &aryBindings)
        
        viewModel.$bDidSelected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] didSelected in
                self?.btnCategory.isSelected = didSelected
                self?.setSelectedStyle(didSelected)
            })
            .store(in: &aryBindings)
    }
    
    func setSelectedStyle(_ isSelected: Bool) {
        btnCategory.backgroundColor = isSelected ? .lightGray : .white
    }

}
