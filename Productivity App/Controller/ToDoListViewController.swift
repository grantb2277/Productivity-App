//
//  ToDoListViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/28/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase

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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if ItemTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            ItemTableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            ItemTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        ItemTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-do List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            self.ref.child("To-do List").childByAutoId().setValue(textField.text!)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
