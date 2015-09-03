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
    
    func getFirstStudent() -> Student{
        var q = Student.query()
        var obj = q.getFirstObject()
        if (obj == nil) {
            log("请先运行创建对象的例子");
        }
        return obj as! Student
    }

    func logThreadTips() {
        log("这里为了演示方便，用了阻塞线程的方法；在主线程，请使用 xxxInBackground 的异步方法。")
    }
    
    func filterError(error: NSError?) -> Bool{
        if error != nil {
            log("%@", error!)
            return false
        } else {
            return true
        }
    }

    func sourcePath() -> String? {
        var clsName = NSStringFromClass(self.dynamicType) as String
        var range = clsName.rangeOfString(".", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
        var nameRange = Range<String.Index>(start: advance(range!.startIndex,1), end: clsName.endIndex)
        var fileName = clsName.substringWithRange(nameRange)
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "swift", inDirectory: "SourceCode")
    }
    
    func showImage(image: UIImage) {
        var vc: ImageViewController = ImageViewController()
        vc.image = image
        self.demoRunC?.navigationController?.pushViewController(vc, animated: true)
    }
}
