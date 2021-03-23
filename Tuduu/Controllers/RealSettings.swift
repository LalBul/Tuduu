//
//  RealSettings.swift
//  Tuduu
//
//  Created by Вова Сербин on 03.03.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class RealSettings: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let db = Firestore.firestore()
    
    @IBAction func logOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
