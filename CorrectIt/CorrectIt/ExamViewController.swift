//
//  ExamViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/09/28.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

class ExamViewController: UIViewController {
    var exam = Exam()
    let fileManage = FileManage()
    var tableView = UITableView()
    var segmentView = UISegmentedControl();
    let realm = try! Realm()
    var paperData: Results<Paper>!
    var colorData: Results<Color>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = exam.subject + "の回答"
        self.view.backgroundColor = UIColor.white
        paperData = realm.objects(Paper.self).filter("examId = %@", exam.id)
        notificationToken = realm.observe { [unowned self] note, realm in
            self.segmentView.selectedSegmentIndex = 0
            self.paperData = realm.objects(Paper.self).filter("examId = %@", self.exam.id)
            self.tableView.reloadData()
        }
        setUI()
    }
    
    func setUI() {
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        segmentView = UISegmentedControl(items: ["個人別", "問題別"])
        segmentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        segmentView.selectedSegmentIndex = 0
        segmentView.addTarget(self, action: #selector(ExamViewController.segmentSelected(segment:)), for: UIControl.Event.valueChanged)
        view.addSubview(segmentView)
        
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "回答追加", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MainViewController.tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func segmentSelected(segment:UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            paperData = realm.objects(Paper.self).filter("examId = %@", exam.id)
            tableView.reloadData()
            print("a")
        case 1:
            colorData = realm.objects(Color.self).filter("examId = %@", exam.id)
            tableView.reloadData()
            print("b")
        default:
            print("a")
        }
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

extension ExamViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentView.selectedSegmentIndex == 0 {
            print("bbbb")
            return paperData.count
        } else if segmentView.selectedSegmentIndex == 1 {
            print("aaaa")
            return colorData.count
        } else {
            return paperData.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if segmentView.selectedSegmentIndex == 0 {
            cell.textLabel?.text = paperData[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        } else if segmentView.selectedSegmentIndex == 1 {
            cell.textLabel?.text = colorData[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = paperData[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension ExamViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PaperViewController()
        if segmentView.selectedSegmentIndex == 0 {
            controller.paper = paperData[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            print("sss")
        }
    }
}
