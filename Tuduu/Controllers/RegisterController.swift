//
//  RegisterController.swift
//  Tuduu
//
//  Created by Вова Сербин on 12.02.2021.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavigationBar()
        register.layer.cornerRadius = 10
    }
    
    @IBAction func goToMainScreen(_ sender: UIButton) {
        if let email = loginTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("У вас ошибка => \(e.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: K.registerToScreen, sender: nil)
                }
            }
        }
    }
    
}

