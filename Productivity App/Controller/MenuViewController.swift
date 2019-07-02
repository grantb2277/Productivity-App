//
//  MenuViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 7/1/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var menuTableView: UITableView!
    
    var menuItems = ["To-do", "Calendar", "Planner", "Settings"]
    var menuIcons = ["toDoListIcon", "calendarIcon", "plannerIcon", "settingsIcon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        //TODO: Register your MenuItemCellfile here:
        menuTableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "customMenuItemCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "customMenuItemCell", for: indexPath) as! CustomMenuItemCell
        cell.menuItemText?.text = menuItems[indexPath.row]
        cell.menuImageView.image = UIImage(named: menuIcons[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You pressed row \(indexPath.row)")
        
        if (indexPath.row == 0) {
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "goToToDo", sender: self)
        } else if (indexPath.row == 1) {
            performSegue(withIdentifier: "goToCalendar", sender: self)
        } else if (indexPath.row == 2) {
            
        } else {
            
        }
        
    }
    
    
}
