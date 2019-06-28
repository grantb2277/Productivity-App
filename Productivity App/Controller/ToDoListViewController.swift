//
//  ToDoListViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/28/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase

class ToDoListViewController: UIViewController, UITableViewDelegate {
    
    var itemArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWillAppear(false)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = animated
    }

}
