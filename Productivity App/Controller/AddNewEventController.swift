//
//  AddNewEventController.swift
//  Productivity App
//
//  Created by Grant Brooks on 7/28/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddNewEventController: UIViewController {
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var newEventText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        if newEventText.text != "" {
            let dateAsString = self.dateFormatter.string(from: self.datePicker.date)
            let newEvent = self.ref.child("Calendar").child(dateAsString).childByAutoId()
            newEvent.setValue(newEventText.text)
            dailyKeys[dateAsString]?.append(newEvent.key!)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    
    //    var textField = UITextField()
//
//    let alert = UIAlertController(title: "Add New Event", message: "", preferredStyle: .alert)
//
//    let action = UIAlertAction(title: "Add Event", style: .default) { (action) in
//        //what will happen once the user clicks the Add Item button on our UIAlert
//
//        //            let dateAsString = self.dateFormatter.string(from: self.selectedDate)
//        //            self.ref.child("Calendar").child(dateAsString).child(textField.text!).setValue(textField.text!)
//
//        let dateAsString = self.dateFormatter.string(from: self.selectedDate)
//        let newEvent = self.ref.child("Calendar").child(dateAsString).childByAutoId()
//        newEvent.setValue(textField.text!)
//        dailyKeys[dateAsString]?.append(newEvent.key!)
//
//    }
//
//    let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
//        //what will happen once the user clicks the Cancel button on our UIAlert
//        alert.dismiss(animated: true, completion: {
//
//        })
//
//    }
//
//    alert.addTextField { (alertTextField) in
//    alertTextField.placeholder = "Create new event"
//    textField = alertTextField
//    }
//
//    alert.addAction(action)
//    alert.addAction(cancel)
//    present(alert, animated: true, completion: nil)
    
}
