//
//  ToDoListViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/28/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
//import CoreMotion

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    //Get rid of the Core Motion Errors
//    var motionManager: CMMotionManager!
    
    var databaseHandle: DatabaseHandle?
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var ItemTableView: UITableView!
    
    var itemArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Get rid of the Core Motion Errors
//        motionManager = CMMotionManager()
//        motionManager.stopActivityUpdates
        
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
    
    
    
}
