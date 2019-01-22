//
//  AddPaperViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/09/28.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

class AddPaperViewController: UIViewController {
    var examId = ""
    let realm = try! Realm()
    var data = [String]()
    var baseView = UIView()
    var tableView = UITableView()
    var selectedData = [String]()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShow),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillClose),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
        let realm = try! Realm()
        if realm.objects(Exam.self).filter("id like '" + examId + "'").count > 0 {
            let exam = realm.objects(Exam.self).filter("id like '" + examId + "'")[0]
            let formatter = DateFormatter()
            formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
            data = FileManage().getFiles(path: documentPath + "/" + exam.subject + formatter.string(from: exam.date))
        }
        setUI()
    }
    
    func setUI() {
        self.view.tag = 1
        baseView = UIView(frame: CGRect(x: 0, y: view.bounds.height - view.bounds.height / 4, width: view.bounds.width, height: view.bounds.height / 4))
        baseView.backgroundColor = UIColor.white
        
        // top border of baseView
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        baseView.layer.addSublayer(topBorder)
        view.addSubview(baseView)
        
        // tableView
        tableView.frame = CGRect(x: 50, y: 30, width: baseView.bounds.width - 100, height: 130)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsMultipleSelection = true
        baseView.addSubview(tableView)
        
        // submit button
        let submitButton = UIButton(frame: CGRect(x: baseView.frame.width - 150, y: tableView.frame.maxY + 30, width: 100, height: 50))
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitle("追加", for: UIControl.State.normal)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(self.pressSubmit(_:)), for: .touchUpInside)
        baseView.addSubview(submitButton)

        // cancel button
        let cancelButton = UIButton(frame: CGRect(x: baseView.frame.width - 280, y: tableView.frame.maxY + 30, width: 100, height: 50))
        cancelButton.backgroundColor = UIColor.red
        cancelButton.setTitle("キャンセル", for: UIControl.State.normal)
        cancelButton.titleLabel?.textColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(self.pressCancel(_:)), for: .touchUpInside)
        baseView.addSubview(cancelButton)

    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    @objc func pressSubmit(_ sender: UIButton){
        print(selectedData)
        for e in selectedData {
            
            let paper = Paper()
            paper.examId = examId
            paper.name = String(e.split(separator: ".")[0])
            let exam = realm.objects(Exam.self).filter("id like '" + examId + "'")[0]
            let formatter = DateFormatter()
            formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
            paper.path = "/" + exam.subject + formatter.string(from: exam.date) + "/" + e
            print(paper.path)
            if realm.objects(Paper.self).filter("examId like '" + examId + "'").filter("name like '" + paper.name + "'").count == 0 {
                try! realm.write() {
                    realm.add(paper)
                }
                if let saved = realm.objects(Paper.self).filter("examId = %s AND name = %s", examId, paper.name).first {
                    print(saved)
                    saveQuestionsInRealm(
                        image: UIImage.init(contentsOfFile: documentPath + saved.path)!,
                        imagePath: documentPath + saved.path,
                        paper: saved
                    );
                }
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pressCancel(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            baseView.frame = CGRect(x: 0, y: view.bounds.height - view.bounds.height / 4 - keyboardHeight, width: view.bounds.width, height: view.bounds.height / 4)
        }
    }
    
    @objc func keyboardWillClose(_ notification: Notification) {
        baseView.frame = CGRect(x: 0, y: view.bounds.height - view.bounds.height / 4, width: view.bounds.width, height: view.bounds.height / 4)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: Any in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == self.view.tag {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func saveQuestionsInRealm(image: UIImage, imagePath: String, paper: Paper) {
        let result = OpenCVManager.detectProcess(image) as NSMutableDictionary
        var splitedImagePath = imagePath.components(separatedBy: ".")
        splitedImagePath.removeLast()
        var basePathList = splitedImagePath.joined(separator: "/").split(separator: "/")
        let dir = String(basePathList.removeLast())
        let basePath = basePathList.joined(separator: "/")
        
        for item in result {
            let splitted = (item.key as! String).components(separatedBy: ":")
            let colorCode = splitted[2]
            let im = item.value as! UIImage
            FileManage().createDirectory(basePath: basePath, dir: dir)
            FileManage().saveImage(path: basePath + "/" + dir + "/\(colorCode).png", image: im)
            if realm.objects(Color.self).filter("examId = %s", examId).count < result.count {
                let color = Color()
                try! realm.write() {
                    color.color = colorCode
                    color.examId = examId
                    color.id = realm.objects(Color.self).filter("examId = %s", examId).count
                    color.name = colorCode
                    realm.add(color)
                }
                
                let question = Question()
                try! realm.write() {
                    question.colorId = color.id
                    question.coordinate = Coordinate()
                    question.coordinate?.x = Int(splitted[0])!
                    question.coordinate!.y = Int(splitted[1])!
                    question.paperId = paper.id
                    question.path = basePath + "/" + dir + "/\(colorCode).png"
                    question.examId = examId
                    realm.add(question)
                }
            } else {
                let colorOp = ColorOperation()
                let colors = realm.objects(Color.self).filter("examId = %s", examId)
                
                var colordiffs: [[Any]] = colors.map {
                    [colorOp.getColorDifference(rgb1: colorOp.getRGBFromHEX(hex: $0.color), rgb2: colorOp.getRGBFromHEX(hex: colorCode)), $0.id]
                }
                colordiffs.sort {$0[0] as! Int > $1[0] as! Int}
                
                let question = Question()
                question.colorId = colordiffs.reversed().first?[1] as! Int
                question.coordinate = Coordinate()
                question.coordinate?.x = Int(splitted[0])!
                question.coordinate!.y = Int(splitted[1])!
                question.paperId = paper.id
                question.path = basePath + "/" + dir + "/\(colorCode).png"
                question.examId = examId
                
                try! realm.write() {
                    realm.add(question)
                }
            }
            print("colorCode: \(colorCode)")
        }
    }
}

extension AddPaperViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        cell.accessoryType = .none
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        if selectedIndexPaths != nil && (selectedIndexPaths?.contains(indexPath))! {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension AddPaperViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select - \(indexPath)")
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        selectedData.append(data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect - \(indexPath)")
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        selectedData.remove(at: selectedData.firstIndex(of: data[indexPath.row])!)
    }
}
