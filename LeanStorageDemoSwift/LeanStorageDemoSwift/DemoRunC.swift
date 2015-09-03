//
//  DemoRunC.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class DemoRunC: UIViewController {
    var demo : Demo?
    var sourceCodeView: UIWebView?
    var methodName : String = ""
    var runBtn: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        var textView = UITextView(frame: view.frame)
        textView.editable = false
        textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        view.addSubview(textView)
        
        textView.text = "点击右上角'运行'按钮查看运行结果\n"
        
        demo?.outputView = textView
        
        runBtn = UIBarButtonItem(title: "运行", style: UIBarButtonItemStyle.Plain, target: self, action: "run")
        navigationItem.rightBarButtonItem = self.runBtn
        getMethodSourceCode()
    }
    
    func finish() {
        runBtn?.title = "再次运行"
        navigationItem.rightBarButtonItem = runBtn
    }
    
    func run() {
        var av = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        av.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: av)
        var sel = NSSelectorFromString(methodName)
        
        UIControl().sendAction(sel, to: demo!, forEvent: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMethodSourceCode (){
        if (demo?.sourcePath() != nil) {
            var code = String(contentsOfFile: (demo?.sourcePath())!, encoding: NSUTF8StringEncoding, error: nil)
            if code != nil {
                var ptn = "func\\s{0,}\(self.methodName).*?\\{(.*?)\n    \\}"
                var error: NSError?
                var re = NSRegularExpression(pattern: ptn, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &error)
                if (error != nil) {
                    
                } else {
                    var result: NSTextCheckingResult? = re!.firstMatchInString(code!, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, count(code!)))
                    if (result != nil) {
                        var nsRange : NSRange = result!.rangeAtIndex(1)
                        var range = Range<String.Index>(start: advance(code!.startIndex, nsRange.location), end: advance(code!.startIndex, nsRange.location + nsRange.length))
                        var methodeCode = code?.substringWithRange(range)
                        var sc = SourceC()
                        addChildViewController(sc)
                        sc.setupWebView()
                        view.addSubview(sc.webView)
                        sourceCodeView = sc.webView
                        var f = demo!.outputView!.frame
                        var height = f.size.height * 0.5
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            sc.webView.frame = CGRectMake(0, f.origin.y, f.size.width, height)
                            sc.webView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
                            self.demo!.outputView!.frame = CGRectMake(0, f.origin.y + height, f.size.width, f.size.height - height)
                        })
                        sc.loadCode(methodeCode)
                    }
                }
            }
        }
    }
    
}
