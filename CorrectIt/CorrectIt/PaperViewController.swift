//
//  PaperViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2018/10/05.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import UIKit

class PaperViewController: UIViewController {
    let paperView = UIImageView()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var paper = Paper()
    
    override func viewDidLoad() {
        setUI()
    }
    
    func setUI() {
        paperView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        paperView.image = UIImage.init(contentsOfFile: documentPath + paper.path)
        view.addSubview(paperView)
    }
}
