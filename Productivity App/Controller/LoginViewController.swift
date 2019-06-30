//
//  LoginViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/15/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
//        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Login was successful")
//                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToToDo", sender: self)
            }
        }
        
    }
    
    
}
