//
//  Demo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit
import AVOSCloud

class Demo: NSObject {
    var outputView : UITextView?
    var demoRunC : DemoRunC?
    var alertViewHelper: AlertViewHelper = AlertViewHelper()
    
    override required init() {
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
        let myClass: AnyClass = anyObject.classForCoder
        let properties = class_copyPropertyList(myClass, &propertyCount)
        for i in 0..<numericCast(propertyCount) {
            let property: objc_property_t = properties[i]
            let cattrs = property_getAttributes(property)
            var attr = String.fromCString(cattrs)
            let cname = property_getName(property)
            let name = String.fromCString(cname)!
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
        let myClass: AnyClass = anyObject.classForCoder;
        let properties = class_copyPropertyList(myClass, &count);
        
        // iterate each objc_property_t struct
        for var i: UInt32 = 0; i < count; i++ {
            let property = properties[Int(i)];
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property);
            
            // covert the c string into a Swift string
            let name = String.fromCString(cname);
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
        let msg = String(format: format, arguments: args)
        print(msg)
        let text = outputView?.text
        outputView?.text = text?.stringByAppendingFormat("\n-------- RUN --------\n%@", msg)
        finish()
    }
    
    func getNthStudent(skip: Int) -> Student{
        let q = Student.query()
        q.skip = skip
        let obj = q.getFirstObject()
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
        let clsName = NSStringFromClass(self.dynamicType) as String
        let range = clsName.rangeOfString(".", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
        let nameRange = Range<String.Index>(start: range!.startIndex.advancedBy(1), end: clsName.endIndex)
        let fileName = clsName.substringWithRange(nameRange)
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "swift", inDirectory: "SourceCode")
    }
    
    func showImage(image: UIImage) {
        let vc: ImageViewController = ImageViewController()
        vc.image = image
        self.demoRunC?.navigationController?.pushViewController(vc, animated: true)
    }
}
