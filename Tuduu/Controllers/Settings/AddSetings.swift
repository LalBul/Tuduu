//
//  AddSetings.swift
//  Tuduu
//
//  Created by Вова Сербин on 23.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddSetings: UIViewController {
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainText: UITextField!
    @IBOutlet weak var optionalText: UITextView!
    
    let db = Firestore.firestore()
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 25
        mainText.layer.cornerRadius = 20
        optionalText.layer.cornerRadius = 15
        completeButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func completeButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        if let task = mainText.text, let opText = optionalText.text {
            
            db.collection(K.T.tasks).addDocument(data: [
                K.T.textTask: task,
                K.T.date: Date().timeIntervalSince1970,
                K.T.optionalTask: opText
            ])
            { (error) in
                if let e = error {
                    print("Возникла проблема с сохранением данных в Firestore, \(e)")
                } else {
                    print("Успешно сохраненные данные")
                }
            }
            
        }
        mainText.text = ""
        optionalText.text = ""
    }
    
}

