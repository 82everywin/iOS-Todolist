//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by 한현승 on 5/29/24.
//

import Foundation
import UIKit

class TodoDetailViewController: UIViewController {
    var selectedTodo : Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
