//
//  ViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/04/13.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    let fileManage = FileManage()
    var tableView = UITableView()
    let realm = try! Realm()
    var data: Results<Exam>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CorrectIt"
        self.view.backgroundColor = UIColor.lightGray
        data = realm.objects(Exam.self)
        setUI()
        print(data.count)
    }

    func setUI() {
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
        
        cell.textLabel?.text = "a"
        cell.accessoryType = .disclosureIndicator
        //cell.accessoryView = UISwitch()
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
