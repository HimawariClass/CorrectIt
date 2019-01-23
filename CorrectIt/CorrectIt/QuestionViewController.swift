//
//  QuestionViewController.swift
//  CorrectIt
//
//  Created by Taillook on 2019/01/23.
//  Copyright © 2019 HimawariClass. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    let paperView = UIImageView()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var question = Question()
    var exam = Exam()
    var tapLocation1 = CGPoint()
    var tapLocation2 = CGPoint()
    var linePath = UIBezierPath()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        setUI()
    }
    
    func setUI() {
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PaperViewController.tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        let formatter = DateFormatter()
        formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
        var image: UIImage? = UIImage.init(contentsOfFile: documentPath + "/" + exam.subject + formatter.string(from: exam.date) + question.path)
        print("読み込み")
        if image == nil {
            image = UIImage()
            let alert:UIAlertController = UIAlertController(title:"エラー",
                                                            message: "画像が読み込めません",
                                                            preferredStyle: UIAlertController.Style.alert)
            let cancelAction:UIAlertAction = UIAlertAction(title: "閉じる",
                                                           style: UIAlertAction.Style.cancel,
                                                           handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        paperView.frame = CGRect(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        paperView.image = image
        paperView.contentMode = .scaleAspectFit
        paperView.frame = paperView.aspectFitFrame!
        paperView.isUserInteractionEnabled = true
        paperView.tag = 256
        view.backgroundColor = UIColor.black
        view.addSubview(paperView)
        print("表示")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case 256:
                tapLocation1 = touch.location(in: touch.view!)
            default:
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case 256:
                tapLocation2 = touch.location(in: touch.view!)
                drawLineFromPoint(start: tapLocation1, toPoint: tapLocation2, ofColor: UIColor.blue, inView: paperView)
                tapLocation1 = tapLocation2
            default:
                break
            }
        }
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.close()
        //path.append(path)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 2.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Disappear")
    }
    
    @objc func tapAddButton() {
        let targetImageView = paperView
        let targetImage = targetImageView.asImage()
        let formatter = DateFormatter()
        formatter.dateFormat = "-yyyy-MM-dd-HH-mm-ss"
        let size = UIImage.init(contentsOfFile: documentPath + "/" + exam.subject + formatter.string(from: exam.date) + question.path)?.size
        FileManage().saveImage(path: documentPath + "/" + exam.subject + formatter.string(from: exam.date) + question.path, image: targetImage.resize(size: CGSize(width: (size?.width)!, height: (size?.height)!))!)
        navigationController?.popViewController(animated: true)
    }
    
}

