//
//  LoadingViewController.swift
//  ToDoList
//
//  Created by yuhan on 2024/6/25.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var vIndicatorView: UIActivityIndicatorView!
    @IBOutlet var vBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vBackgroundView.addCornerRadius()
        vIndicatorView.startAnimating()
    }
}
