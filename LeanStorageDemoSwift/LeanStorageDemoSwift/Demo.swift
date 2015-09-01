//
//  Demo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class Demo: NSObject {
    var outputView : UITextView?
    var demoRunC : DemoRunC?
    
    func allDemoMethods () -> [String]{
        var mts = [String]()
        
        var cls = self
        var methodCount : UInt32 = 0
        let methods = class_copyMethodList(object_getClass(self), &methodCount)
        for i in 0..<numericCast(methodCount) {
            let method: Method = methods[i]
            let selector: Selector = method_getName(method)
            mts += [String(_sel:selector)]
        }
        return mts
    }
    
    func finish() {
        demoRunC?.finish();
    }
    
    func log(format: String, _ args:CVarArgType...) {
        var msg = String(format: format, arguments: args)
        println(msg)
        var text = outputView?.text
        outputView?.text = text?.stringByAppendingFormat("\n-------- RUN --------\n%@", msg)
        finish()
    }

}
