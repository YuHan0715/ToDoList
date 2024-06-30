//
//  PickerViewController.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/29.
//

import UIKit
import Combine

class PickerViewController: BaseViewModelController<PickerViewModel>, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var vBackground: UIView!
    
    var aryBindings = Set<AnyCancellable>()

    override func initView() {
        super.initView()
        vBackground.addCornerRadius()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClose))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        picker.selectRow(viewModel.iSelectedIndex, inComponent: 0, animated: true)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        btnConfirm.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                let selectedIndex = viewModel.iSelectedIndex
                let selectedTitle = viewModel.aryOptions[selectedIndex]
                viewModel.didSelectedItem.send((selectedTitle, selectedIndex))
                self.dismiss(animated: true)
            })
            .store(in: &aryBindings)
    }
    
    @objc private func tapClose() {
        dismiss(animated: true)
    }

}


extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.iSelectedIndex = row
        viewModel.didSelectedItem.send((viewModel.aryOptions[row], row))
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.aryOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.aryOptions[row]
    }
}
