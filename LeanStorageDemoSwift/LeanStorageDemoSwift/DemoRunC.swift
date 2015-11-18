//
//  DemoRunC.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
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
        let textView = UITextView(frame: view.frame)
        textView.editable = false
        textView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
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
        let av = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        av.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: av)
        let sel = NSSelectorFromString(methodName)
        
        UIControl().sendAction(sel, to: demo!, forEvent: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMethodSourceCode (){
        if (demo?.sourcePath() != nil) {
            let code = try? String(contentsOfFile: (demo?.sourcePath())!, encoding: NSUTF8StringEncoding)
            if code != nil {
                let ptn = "func\\s{0,}\(self.methodName).*?\\{(.*?)\n    \\}"
                var error: NSError?
                var re: NSRegularExpression?
                do {
                    re = try NSRegularExpression(pattern: ptn, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
                } catch let error1 as NSError {
                    error = error1
                    re = nil
                }
                if (error != nil) {
                    
                } else {
                    let result: NSTextCheckingResult? = re!.firstMatchInString(code!, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, (code!).characters.count))
                    if (result != nil) {
                        let nsRange : NSRange = result!.rangeAtIndex(1)
                        let range = Range<String.Index>(start: code!.startIndex.advancedBy(nsRange.location), end: code!.startIndex.advancedBy(nsRange.location + nsRange.length))
                        let methodeCode = code?.substringWithRange(range)
                        let sc = SourceC()
                        addChildViewController(sc)
                        sc.setupWebView()
                        view.addSubview(sc.webView)
                        sourceCodeView = sc.webView
                        let f = demo!.outputView!.frame
                        let height = f.size.height * 0.5
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
