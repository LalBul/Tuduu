//
//  MainTuduu.swift
//  Tuduu
//
//  Created by Вова Сербин on 09.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class MainTuduu: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var searchTask: UITextField!
    @IBOutlet weak var addTask: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var arrayTest: [Task] = []
    
    var finalSearch: [SearchTask] = []
    let db = Firestore.firestore()
    var uniqueUnordered: [SearchTask] = []
    
    var realIndex = 0
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideNavigationBar()
        loadTask()
    }
    
    override func viewDidLoad() {
        
        self.hideNavigationBar()
        super.viewDidLoad()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        
        addTask.layer.cornerRadius = 15
        
        searchTask.attributedPlaceholder = NSAttributedString(string: "Search",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTask.delegate = self
        
        taskTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        settingsButton.setImage(UIImage(named: "Geer wheel"), for: .normal)
        settingsButton.layer.cornerRadius = 15
        
        loadTask()
        
    }
    
    //MARK: - Load data in array
    func loadTask() {
        
        arrayTest = []
        db.collection(K.T.tasks)
            .order(by: K.T.date)
            .addSnapshotListener { (querySnapshot, error) in
                self.arrayTest = []
                if let e = error {
                    print("There was an issue retrieving data from a Firestore => \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let task = data[K.T.textTask] as? String, let optionalTask = data[K.T.optionalTask] as? String {
                                let taskFinal = Task(textTask: task, optionalTesk: optionalTask)
                                self.arrayTest.append(taskFinal)
                                
                                DispatchQueue.main.async {
                                    self.taskTableView.reloadData()
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    
    
    
    @IBAction func goSettings(_ sender: UIButton) {
        
    }
    
    
}

//MARK: - Settings TableView

extension MainTuduu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTask.text != "" {
            return uniqueUnordered.count
        } else {
            return arrayTest.count // Тут будет значение кол-ва ячеек
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        realIndex = indexPath.row
        if searchTask.text != "" {
            performSegue(withIdentifier: K.toSettingForSearch, sender: nil)
        } else {
            performSegue(withIdentifier: K.toSetting, sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ToDoListMain // Тут мы создаем ячейку. В withIdentifier вставляем название(идентификатор) ячейки в файле .xib , as'ом говорим что-бы взял ее из файла с соответствующим названием ToDoListMain
        let cell2 = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ToDoListMain
        if searchTask.text != "" {
            cell2.label.text = uniqueUnordered[indexPath.row].mainSearchText
            return cell2
        } else {
            cell.label.text = arrayTest[indexPath.row].textTask
            return cell
        }
        
    }
    
    //MARK: - Go to the task settings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var number = 0
        if segue.identifier == K.toSetting {
            number = 0
            let destinationVC = segue.destination as! ViewSettings
            db.collection(K.T.tasks).getDocuments { (querySnapshot, error) in
                if let snapshot = querySnapshot?.documents {
                    for _ in snapshot {
                        if number == self.realIndex {
                            destinationVC.mainText.text = self.arrayTest[number].textTask // Передача данных в View с изменением данных
                            destinationVC.optionalText.text = self.arrayTest[number].optionalTesk
                        }
                        number += 1
                    }
                }
            }
        } else if segue.identifier == K.toSettingForSearch {
            number = 0
            let destinationVC = segue.destination as! SettingsTaskForSearch
            db.collection(K.T.tasks).getDocuments { (querySnapshot, error) in
                if let snapshot = querySnapshot?.documents {
                    for _ in snapshot {
                        if number == self.realIndex {
                            print(self.uniqueUnordered[number].mainSearchText)
                            destinationVC.trueMain = self.uniqueUnordered[number].mainSearchText
                            destinationVC.trueOptional = self.uniqueUnordered[number].optionalSearchText
                        }
                        number += 1
                    }
                }
            }
            searchTask.text = ""
        }
    }
    
    
}

//MARK: - Search for a task

extension MainTuduu: UITextFieldDelegate {
    
    @IBAction func searchTask(_ sender: UITextField) {
        searchForTheDesiredTask()
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    func searchForTheDesiredTask() {
        var searchTaskNew = ""
        uniqueUnordered = []
        if searchTask.text != "" {
            for text in searchTask.text! {
                searchTaskNew.append(String(text))
                for textPoint in 0..<arrayTest.count {
                    for textArray in arrayTest[textPoint].textTask {
                        if searchTaskNew == String(textArray) {
                            let taskFinal = SearchTask(mainSearchText: arrayTest[textPoint].textTask, optionalSearchText: arrayTest[textPoint].optionalTesk)
                            uniqueUnordered.append(taskFinal)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Кнопка go
        searchTask.endEditing(true)
    }
    
    
}

