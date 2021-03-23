//
//  LoginController.swift
//  Tuduu
//
//  Created by Вова Сербин on 13.02.2021.
//


import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var login: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavigationBar()
        login.layer.cornerRadius = 10
    }
    
    @IBAction func goToMainScreen(_ sender: UIButton) {
        if let email = loginTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self!.performSegue(withIdentifier: K.loginToScreen, sender: nil)
                }
            }
            
            
        }
        
    }
    
}

