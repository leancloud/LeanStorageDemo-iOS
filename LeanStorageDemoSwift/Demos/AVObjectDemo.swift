//
//  AVObjectDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class AVObjectDemo: Demo {
    
    func demoCreateObject() {
        var student = Student()
        student.name = "Mike"
        student.age = 12
        student.save()
        log("创建成功:%@", student)
    }
    
}
