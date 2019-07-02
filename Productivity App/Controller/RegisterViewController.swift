//
//  RegisterViewController.swift
//  Productivity App
//
//  Created by Grant Brooks on 6/15/19.
//  Copyright © 2019 Grant Brooks. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect.init(x: 162.5, y: 218, width: 50, height: 50), type: .lineSpinFadeLoader, color: .lightGray, padding: CGFloat.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        passwordTextField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlength: 8;")
        
        //TODO: Register the user
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration was successful")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "startAtToDo", sender: self)
            }
        }
        
    }
    
    
    
}
