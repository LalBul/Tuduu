//
//  ViewSettings.swift
//  Tuduu
//
//  Created by Вова Сербин on 27.02.2021.
//


import UIKit
import Firebase
import FirebaseFirestore

class ViewSettings: UIViewController {
    
    
    @IBOutlet weak var mainText: UITextField!
    @IBOutlet weak var optionalText: UITextView!
    
    let db = Firestore.firestore()
    
    var trueTextMain: String = ""
    var trueOptionalText: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let textMain = mainText.text {
            trueTextMain = textMain
        }
        if let textOptional = optionalText.text {
            trueOptionalText = textOptional
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainText.layer.cornerRadius = 15
        optionalText.layer.cornerRadius = 10
        hideNavigationBar()
        
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        
        db.collection(K.T.tasks).getDocuments { (querySnapshot, error) in
            if let snap = querySnapshot?.documents {
                for doc in snap {
                    let docID = doc.documentID
                    let docRef = self.db.collection(K.T.tasks).document(docID)
                    docRef.getDocument { (documentSnapshot, error) in
                        if let document = documentSnapshot, document.exists {
                            let realDocument = document[K.T.textTask] as? String
                            let realDocument2 = document[K.T.optionalTask] as? String
                            if realDocument! == self.trueTextMain && realDocument2 == self.trueOptionalText {
                                self.db.collection(K.T.tasks).document(docID).updateData([
                                    K.T.textTask: self.mainText.text ?? "-",
                                    K.T.optionalTask: self.optionalText.text ?? "-" 
                                ])
                                { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } 
        navigationController?.popViewController(animated: true)
    }
    
}

