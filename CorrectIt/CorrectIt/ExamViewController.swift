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
    var tableView1 = UITableView()
    var tableView2 = UITableView()
    var segmentView = UISegmentedControl();
    let realm = try! Realm()
    var paperData: Results<Paper>!
    var colorData: Results<Color>!
    var notificationToken: NotificationToken?
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = exam.subject + "の回答"
        self.view.backgroundColor = UIColor.white
        paperData = realm.objects(Paper.self).filter("examId = %@", exam.id)
        colorData = realm.objects(Color.self).filter("examId = %@", exam.id)
        notificationToken = realm.observe { [unowned self] note, realm in
            self.segmentView.selectedSegmentIndex = 0
            self.paperData = realm.objects(Paper.self).filter("examId = %@", self.exam.id)
            self.tableView1.reloadData()
        }
        setUI()
    }
    
    func setUI() {
        navigationController?.navigationBar.isTranslucent = false
        
        tableView1.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView1.register(UINib(nibName: "EachColorCell", bundle: nil), forCellReuseIdentifier: "EachColor")
        tableView1.tableFooterView = UIView(frame: .zero)
        tableView1.tag = 111
        view.addSubview(tableView1)
        
        tableView2.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView2.register(UINib(nibName: "EachColorCell", bundle: nil), forCellReuseIdentifier: "EachColor")
        tableView2.tableFooterView = UIView(frame: .zero)
        tableView2.tag = 222
        tableView2.isHidden = true
        view.addSubview(tableView2)
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
            tableView1.reloadData()
            tableView1.isHidden = false
            tableView2.isHidden = true
            print("a")
        case 1:
            colorData = realm.objects(Color.self).filter("examId = %@", exam.id)
            tableView2.reloadData()
            tableView1.isHidden = true
            tableView2.isHidden = false
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
        if tableView.tag == 111 {
            print("bbbb")
            return paperData.count
        } else if tableView.tag == 222 {
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let colorCell = tableView.dequeueReusableCell(withIdentifier: "EachColor") as! EachColorCell
        
        if tableView.tag == 111 {
            cell.textLabel?.text = paperData[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        } else if tableView.tag == 222 {
            colorCell.mainLabel.text = colorData[indexPath.row].name
            let id = colorData[indexPath.row].id
            let question = realm.objects(Question.self).filter("examId = %@ AND colorId = %@", exam.id, id).first
//            let clorlist = ColorOperation().getRGBFromHEX(hex: colorData[indexPath.row].color)
            let formatter = DateFormatter()
            formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
            colorCell.imgView.image = UIImage.init(contentsOfFile: documentPath + "/" + exam.subject + formatter.string(from: exam.date) + question!.path)
            colorCell.imgView.backgroundColor = UIColor.blue
            colorCell.exLabel.text = colorData[indexPath.row].color
            return colorCell
        } else {
            cell.textLabel?.text = paperData[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension ExamViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentView.selectedSegmentIndex == 0 {
            let controller = PaperViewController()
            controller.paper = paperData[indexPath.row]
            controller.exam = exam
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = QuestionListViewController()
            controller.exam = exam
            controller.color = colorData[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
