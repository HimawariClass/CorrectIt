//
//  AddExamViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/09/27.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

class AddExamViewController: UIViewController {
    let realm = try! Realm()
    var data: Results<Exam>!
    var baseView = UIView()
    var descField = UITextField()
    var titleField = UITextField()
    
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
        
        // title(subject)
        titleField = UITextField(frame: CGRect(x: 50, y: 30, width: view.bounds.width - 100, height: 50))
        titleField.backgroundColor = UIColor.white
        titleField.addUnderline(width: 1.0, color: UIColor.gray)
        titleField.placeholder = "タイトル"
        baseView.addSubview(titleField)
        
        // description
        descField = UITextField(frame: CGRect(x: 50, y: titleField.frame.maxY + 30, width: view.bounds.width - 100, height: 50))
        descField.backgroundColor = UIColor.white
        descField.addUnderline(width: 1.0, color: UIColor.gray)
        descField.placeholder = "詳細"
        baseView.addSubview(descField)
        
        // submit button
        let submitButton = UIButton(frame: CGRect(x: baseView.frame.width - 150, y: descField.frame.maxY + 30, width: 100, height: 50))
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitle("作成", for: UIControl.State.normal)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        baseView.addSubview(submitButton)
    }
    
    @objc func pressButton(_ sender: UIButton){
        let exam = Exam()
        exam.date = Date()
        exam.subject = titleField.text!
        exam.desc = descField.text!
        if exam.subject != "" && exam.desc != "" {
            try! realm.write() {
                realm.add(exam)
            }
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
