//
//  QuestionListViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2019/01/23.
//  Copyright © 2019 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionListViewController: UIViewController {
    var exam = Exam()
    var color = Color()
    let fileManage = FileManage()
    var tableView = UITableView()
    var textfield = UITextField()
    var button = UIButton()
    let realm = try! Realm()
    var questionData: Results<Question>!
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = exam.subject + "の回答"
        self.view.backgroundColor = UIColor.white
        questionData = realm.objects(Question.self).filter("examId = %@ AND colorId = %@", exam.id, color.id)
        setUI()
    }
    
    func setUI() {
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EachQuestionCell", bundle: nil), forCellReuseIdentifier: "EachQuestion")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tag = 111
        view.addSubview(tableView)
        
        textfield.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 40)
        textfield.text = color.name
        view.addSubview(textfield)
        
        button.frame = CGRect(x: view.frame.width - 100, y: 0, width: 100, height: 40)
        button.setTitle("決定", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(QuestionListViewController.tapChangeNameButton), for: .touchUpInside)
        view.addSubview(button)
        
//        let addButton: UIBarButtonItem = UIBarButtonItem(title: "回答追加", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MainViewController.tapAddButton))
//        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func tapChangeNameButton() {
        try! realm.write {
            color.name = textfield.text ?? color.name
        }
        
        let alert:UIAlertController = UIAlertController(title:"問題名を変更しました",
                                                        message: textfield.text,
                                                        preferredStyle: UIAlertController.Style.alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "閉じる",
                                                       style: UIAlertAction.Style.cancel,
                                                       handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QuestionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EachQuestion") as! EachQuestionCell
        let formatter = DateFormatter()
        formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
        cell.imgView.image = UIImage.init(contentsOfFile: documentPath + "/" + exam.subject + formatter.string(from: exam.date) + questionData[indexPath.row].path)
        return cell
    }
}

extension QuestionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = QuestionViewController()
        controller.question = questionData[indexPath.row]
        controller.exam = exam
        navigationController?.pushViewController(controller, animated: true)
    }
}

