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
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        paperView.frame = CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: view.frame.width, height: view.frame.height - (statusBarHeight + navBarHeight!))
        paperView.image = UIImage.init(contentsOfFile: documentPath + paper.path)
        paperView.contentMode = .scaleAspectFit
        view.addSubview(paperView)
        paperView.isUserInteractionEnabled = true
        paperView.tag = 256
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
}
