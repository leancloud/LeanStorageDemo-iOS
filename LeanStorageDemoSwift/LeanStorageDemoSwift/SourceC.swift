//
//  SourceC.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/2.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit

class SourceC: UIViewController {
    var webView : UIWebView!
    var filePath: String?
    static var html: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        loadSource()
    }
    
    func setupWebView() {
        webView = UIWebView(frame: self.view.bounds)
        webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        webView.scalesPageToFit = true
        webView.opaque = false
        let color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        webView.backgroundColor = color
        view.backgroundColor = color
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCode(code: String?) {
        if code != nil {
            if let htmlRoot = NSBundle.mainBundle().URLForResource("html", withExtension: nil) {
                if SourceC.html == nil {
                    var error: NSError?
                    do {
                        SourceC.html = try String(contentsOfFile: htmlRoot.URLByAppendingPathComponent("index.html").path!, encoding: NSUTF8StringEncoding)
                    } catch let error1 as NSError {
                        error = error1
                        SourceC.html = nil
                    }
                    print(error)
                }
                let range = Range<String.Index>(start: (SourceC.html!).startIndex, end: (SourceC.html!).endIndex)
                let htmlCode: NSString = (SourceC.html!).stringByReplacingOccurrencesOfString("__CODE__", withString: code!, options: NSStringCompareOptions.LiteralSearch, range: range)
                webView.loadHTMLString(htmlCode as String, baseURL: NSURL(fileURLWithPath: htmlRoot.path!, isDirectory: true))
            }
        }
    }
    
    func loadSource() {
        if filePath != nil {
            title = NSURL(fileURLWithPath: filePath!).lastPathComponent
            let code = try? String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
            loadCode(code)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
