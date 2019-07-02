//
//  ToDoListViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/28/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseHandle: DatabaseHandle?
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var ItemTableView: UITableView!
    
    var itemArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ItemTableView.dataSource = self
        self.ItemTableView.delegate = self
        
        databaseHandle = ref.child("To-do List").observe(.childAdded, with: { (snapshot) in
            
            let item = snapshot.value as? String
            if let realItem = item {
                self.itemArray.append(realItem)
                self.ItemTableView.reloadData()
            }
            
        })
        
        // Define the menus
//        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: MenuController)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    //MARK - TableView Datasouce Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ItemTableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.ref.child("To-do List").child(itemArray[indexPath.row]).removeValue()
            self.itemArray.remove(at: indexPath.row)
            self.ItemTableView.reloadData()
        }
    }
    
    
    //MARK - Additonal Features
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-do List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            self.ref.child("To-do List").child(textField.text!).setValue(textField.text!)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //what will happen once the user clicks the Cancel button on our UIAlert
            alert.dismiss(animated: true, completion: {
                
            })
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Now")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}
