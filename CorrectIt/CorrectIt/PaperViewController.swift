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
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        var image: UIImage? = UIImage.init(contentsOfFile: documentPath + paper.path)
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
        paperView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (statusBarHeight + navBarHeight!))
        paperView.image = image
        paperView.contentMode = .scaleAspectFit
        paperView.frame = paperView.aspectFitFrame!
        paperView.isUserInteractionEnabled = true
        paperView.tag = 256
        view.addSubview(paperView)
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
        let size = UIImage.init(contentsOfFile: documentPath + paper.path)?.size
        UIImageWriteToSavedPhotosAlbum(targetImage.resize(size: CGSize(width: (size?.width)!, height: (size?.height)!))!, self, nil, nil)
    }
    
}
