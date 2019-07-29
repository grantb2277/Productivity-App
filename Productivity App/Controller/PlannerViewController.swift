//
//  PlannerViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 7/2/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var sections: [String] = ["This Week", "Next Week", "Upcoming"]
    var weeklyEvents: [String] = ["Weekly"]
    var nextWeekEvents: [String] = ["Next Week"]
    var upcomingEvents: [String] = ["Upcoming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.register(UINib(nibName: "PlannerCell", bundle: nil), forCellReuseIdentifier: "customPlannerCell")
        
        // Define the menus
        //        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: MenuController)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return weeklyEvents.count
        case 1:
            return nextWeekEvents.count
        default:
            return upcomingEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPlannerCell", for: indexPath) as! CustomPlannerCell
        switch indexPath.section {
        case 0:
            cell.cellText.text = weeklyEvents[indexPath.row]
            cell.colorCode.backgroundColor = .black
        case 1:
            cell.cellText.text = nextWeekEvents[indexPath.row]
            cell.colorCode.backgroundColor = .blue
        default:
            cell.cellText.text = upcomingEvents[indexPath.row]
            cell.colorCode.backgroundColor = .green
        }
        
        return cell
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
