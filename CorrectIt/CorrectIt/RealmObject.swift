//
//  SutudentObject.swift
//  CorrectIt
//
//  Created by Taillook on 2018/06/16.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import RealmSwift

class Exam: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var subject = ""
    @objc dynamic var desc = ""
}

class Paper: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var examId = ""
    @objc dynamic var name = ""
    @objc dynamic var path = ""
}

class Question: Object {
    @objc dynamic var paperId = ""
    @objc dynamic var examId = ""
    @objc dynamic var colorId = 0
    @objc dynamic var path = ""
    @objc dynamic var coordinate: Coordinate?
}

class Coordinate: Object {
    @objc dynamic var x = 0
    @objc dynamic var y = 0
}

class Color: Object {
    @objc dynamic var examId = ""
    @objc dynamic var id = 0
    @objc dynamic var color = ""
    @objc dynamic var name = ""
}
