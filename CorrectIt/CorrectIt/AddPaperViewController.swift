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
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let realm = try! Realm()
        if realm.objects(Exam.self).filter("id like '%@'", examId).count == 1 {
            data = FileManage().getFiles(path: documentPath + "/" + realm.objects(Exam.self).filter("id like '%@'", examId)[0].subject)
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
        submitButton.setTitle("作成", for: UIControl.State.normal)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        baseView.addSubview(submitButton)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    @objc func pressButton(_ sender: UIButton){
        let paper = Paper()
        try! realm.write() {
            realm.add(paper)
        }
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
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect - \(indexPath)")
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
}
