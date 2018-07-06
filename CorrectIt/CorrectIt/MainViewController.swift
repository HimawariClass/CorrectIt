//
//  ViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/04/13.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CorrectIt"
        self.view.backgroundColor = UIColor.white
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentPath)
        var fileNames: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentPath)
            } catch {
                return []
            }
        }
        
        print(fileNames)
        
        var fileNames2: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentPath+"/Diary")
            } catch {
                return []
            }
        }
        
        print(fileNames2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

