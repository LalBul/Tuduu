//
//  ToDoListMain.swift
//  Tuduu
//
//  Created by Вова Сербин on 09.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class ToDoListMain: UITableViewCell {
    
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var task: UIView!
    @IBOutlet weak var button: UIButton!
    
    let db = Firestore.firestore()
    var realDocID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        task.layer.cornerRadius = 5 // Закругление
        okButton.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func checkButton(_ sender: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        db.collection(K.T.tasks).getDocuments { (querySnapshot, error) in
            if let snap = querySnapshot?.documents {
                for doc in snap {
                    let docID = doc.documentID
                    let docRef = self.db.collection(K.T.tasks).document(docID)
                    docRef.getDocument { (documentSnapshot, error) in
                        if let document = documentSnapshot, document.exists {
                            let realDocument = document[K.T.textTask] as? String
                            if realDocument! == self.label.text {
                                self.db.collection(K.T.tasks).document(docID).delete()
                            }
                        }
                    }
                }
            }
        }
    }
    

    
}
