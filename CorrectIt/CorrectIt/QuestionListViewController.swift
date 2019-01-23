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
        
//        let addButton: UIBarButtonItem = UIBarButtonItem(title: "回答追加", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MainViewController.tapAddButton))
//        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func tapAddButton() {
        let controller = AddPaperViewController()
        controller.examId = exam.id
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
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
        let controller = PaperViewController()
        print("sss")
    }
}

