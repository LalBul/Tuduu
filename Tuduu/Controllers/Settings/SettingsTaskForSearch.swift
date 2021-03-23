//
//  SettingsTaskForSearch.swift
//  Tuduu
//
//  Created by Вова Сербин on 05.03.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class SettingsTaskForSearch: UIViewController {
    
    var db = Firestore.firestore()
    
    var trueMain: String = ""
    var trueOptional: String = ""
    
    @IBOutlet weak var mainText: UITextField!
    @IBOutlet weak var optionalText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainText.layer.cornerRadius = 15
        optionalText.layer.cornerRadius = 10
        hideNavigationBar()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.mainText.text = self.trueMain
            self.optionalText.text = self.trueOptional
        }
    }
    
    @IBAction func done(_ sender: UIButton) {
        db.collection(K.T.tasks).getDocuments { (querySnapshot, error) in
            if let snap = querySnapshot?.documents {
                for doc in snap {
                    let docID = doc.documentID
                    let docRef = self.db.collection(K.T.tasks).document(docID)
                    docRef.getDocument { (documentSnapshot, error) in
                        if let document = documentSnapshot, document.exists {
                            let realDocument = document[K.T.textTask] as? String
                            let realDocument2 = document[K.T.optionalTask] as? String
                            if realDocument! == self.trueMain && realDocument2 == self.trueOptional{
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
