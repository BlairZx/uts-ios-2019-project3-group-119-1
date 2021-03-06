//
//  AuthViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SwiftOverlays

class LoginViewController: UIViewController {
    var authentication: Authentication = Authentication()
    var loginHandler: AuthStateDidChangeListenerHandle!
    //outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signIn(_ sender: UIButton) {        
        authentication.login(withEmail: emailField.text!, passowrd: passwordField.text! )
    }
    
    
    //detect whether user enters the first character
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = " "
                return
            }
        }
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
            else {
                signInButton.isEnabled = false
                return
        }
        signInButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.isEnabled = false
        
        //listen to text field change
        [emailField, passwordField].forEach({
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loginHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "loginToMainSegue", sender: self)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.loginHandler)
    }
}
