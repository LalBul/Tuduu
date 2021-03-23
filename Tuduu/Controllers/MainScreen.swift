//
//  ViewController.swift
//  Tuduu
//
//  Created by Вова Сербин on 09.02.2021.
//

import UIKit
import CLTypingLabel

class MainScreen: UIViewController {
    
    
    @IBOutlet weak var Tu: CLTypingLabel!
    @IBOutlet weak var duu: CLTypingLabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        login.layer.cornerRadius = 30
        register.layer.cornerRadius = 30
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Tu.text = K.logo1
        duu.text = K.logo2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

