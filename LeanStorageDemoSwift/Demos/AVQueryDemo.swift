//
//  AVQueryDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class AVQueryDemo: Demo {
    func demoBasicQuery() {
        var q = Student.query()
        var students = q.findObjects()
        log("找回了一组学生:%@", students)
    }
    
    func demoGetFirst() {
        var q = Student.query()
        var student = q.getFirstObject()
        log("找回了第一个学生:%@", student)
    }
    
    func demoLimit() {
        var q = Student.query()
        q.limit = 5
        var students = q.findObjects()
        log("找回了五个学生:%@", students)
    }
    
    func demoSkip() {
        var q = Student.query()
        q.orderByAscending("createdAt")
        q.skip = 3
        var student = q.getFirstObject()
        log("找回了第三个创建的学生:%@", student)
    }
}
