//
//  RegisterViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/15/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        //TODO: Register the user
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration was successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToToDo", sender: self)
            }
        }
        
    }
}
