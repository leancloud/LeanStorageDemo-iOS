//
//  Demo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit
import AVOSCloud

class Demo: NSObject {
    var outputView : UITextView?
    var demoRunC : DemoRunC?
    var alertViewHelper: AlertViewHelper = AlertViewHelper()
    
    override init() {
        super.init()
    }
    
    func allDemoMethods (anyObject:AnyObject) -> [String]{
        var mts = [String]()
        var methodCount : UInt32 = 0
        let methods = class_copyMethodList(object_getClass(anyObject), &methodCount)
        for i in 0..<numericCast(methodCount) {
            let method: Method = methods[i]
            let selector: Selector = method_getName(method)
            mts += [String(_sel:selector)]
        }
        return mts
    }
    
    class func allProperties (anyObject: AnyObject) -> [String]{
        var pNames = [String]()
        
        var propertyCount : UInt32 = 0
        var myClass: AnyClass = anyObject.classForCoder
        let properties = class_copyPropertyList(myClass, &propertyCount)
        for i in 0..<numericCast(propertyCount) {
            let property: objc_property_t = properties[i]
            var cattrs = property_getAttributes(property)
            var attr = String.fromCString(cattrs)
            var cname = property_getName(property)
            var name = String.fromCString(cname)!
            let mtd = class_getInstanceMethod(myClass, Selector(name))
            let imp: IMP = method_getImplementation(mtd)
            pNames.append(name)
        }
        return pNames
    }
    
    static func propertyNames(anyObject:AnyObject) -> Array<String> {
        var results: Array<String> = [];
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        var myClass: AnyClass = anyObject.classForCoder;
        var properties = class_copyPropertyList(myClass, &count);
        
        // iterate each objc_property_t struct
        for var i: UInt32 = 0; i < count; i++ {
            var property = properties[Int(i)];
            
            // retrieve the property name by calling property_getName function
            var cname = property_getName(property);
            
            // covert the c string into a Swift string
            var name = String.fromCString(cname);
            results.append(name!);
        }
        
        // release objc_property_t structs
        free(properties);
        
        return results;
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
    
    func getNthStudent(skip: Int) -> Student{
        var q = Student.query()
        q.skip = skip
        var obj = q.getFirstObject()
        if (obj == nil) {
            log("请先运行创建对象的例子");
        }
        return obj as! Student
    }
    
    func getFirstStudent() -> Student{
        return getNthStudent(0)
    }
    
    func getSecoundStudent() -> Student{
        return getNthStudent(1)
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
