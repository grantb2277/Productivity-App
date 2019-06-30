//
//  LoginViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/15/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect.init(x: 162.5, y: 218, width: 50, height: 50), type: .lineSpinFadeLoader, color: .lightGray, padding: CGFloat.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Login was successful")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "goToToDo", sender: self)
            }
        }
        
    }
    
}
