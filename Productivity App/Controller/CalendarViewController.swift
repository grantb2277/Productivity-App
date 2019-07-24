//
//  CalendarViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 7/1/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import FSCalendar

class CalendarViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    var databaseHandle: DatabaseHandle?
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var dailyEvents: [String : [String]] = [:]
    var dailyKeys: [String : [String]] = [:]
    
    var selectedDate: Date = Date()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        let date = snapshot.key
//        let dict = snapshot.value as? NSDictionary
//        var eventArray: [String] = []
//        if let dictionary = dict {
//            for (_, event) in dictionary {
//                let newEvent = event as? String
//                eventArray.append(newEvent!)
//            }
//        }
//        self.dailyEvents[date] = eventArray
//        self.tableView.reloadData()
        
        databaseHandle = ref.child("Calendar").observe(.childAdded, with: { (snapshot) in
            
            let date = snapshot.key
            var eventKey: [String] = []
            var eventArray: [String] = []
            for snap in snapshot.children {
                let event = snap as! DataSnapshot
                let newEvent = event.value as? String
                eventArray.append(newEvent!)
                eventKey.append(event.key)
            }
            self.dailyEvents[date] = eventArray
            self.dailyKeys[date] = eventKey
            self.tableView.reloadData()
            
        })
        
        // Define the menus
        //        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: MenuController)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
        calendar.dataSource = self
        calendar.delegate = self
        
        self.calendar.select(Date())
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(adjustCalendar(swipe:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(adjustCalendar(swipe:)))
        
        swipeUp.direction = .up
        swipeDown.direction = .down
        
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)
        self.calendar.scope = .month
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func adjustCalendar(swipe: UISwipeGestureRecognizer) {
        if (swipe.direction == .up) {
            print("Swipe up")
            self.calendar.setScope(.week, animated: false)
        } else if (swipe.direction == .down) {
            print("Swipe down")
            self.calendar.setScope(.month, animated: false)
        }
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (gestureRecognizer.view != self.tableView) {
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.calendar.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDate = date
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        selectedDate = date
        self.tableView.reloadData()

    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formatDate = self.dateFormatter.string(from: selectedDate)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventItem", for: indexPath)
//        cell.textLabel?.text = dateArray[indexPath.row]
        cell.textLabel?.text = dailyEvents[formatDate]![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dateArray.count
        let formatDate = self.dateFormatter.string(from: selectedDate)
        if let dailyEvents = dailyEvents[formatDate] {
            return dailyEvents.count
        } else {
            return 0
        }
    }
    
    //MARK - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let formatDate = self.dateFormatter.string(from: selectedDate)
            var dateEventArray: [String] = []
            if let test: [String] = dailyKeys[formatDate] {
                dateEventArray = test
            } else {
                dateEventArray = []
            }
            self.ref.child("Calendar").child(formatDate).child(dateEventArray[indexPath.row]).removeValue()
            self.dailyKeys[formatDate]!.remove(at: indexPath.row)
            self.dailyEvents[formatDate]!.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Event", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Event", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
//            let dateAsString = self.dateFormatter.string(from: self.selectedDate)
//            self.ref.child("Calendar").child(dateAsString).child(textField.text!).setValue(textField.text!)
            
            let dateAsString = self.dateFormatter.string(from: self.selectedDate)
            let newEvent = self.ref.child("Calendar").child(dateAsString).childByAutoId()
            newEvent.setValue(textField.text!)
            self.dailyKeys[dateAsString]?.append(newEvent.key!)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //what will happen once the user clicks the Cancel button on our UIAlert
            alert.dismiss(animated: true, completion: {
                
            })
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new event"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}
