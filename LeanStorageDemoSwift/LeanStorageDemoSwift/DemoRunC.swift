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
    var methodName : String = ""
    var runBtn: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        var textView = UITextView(frame: view.bounds)
        textView.editable = false
        textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        view.addSubview(textView)
        
        textView.text = "点击右上角'运行'按钮查看运行结果\n"
        
        demo?.outputView = textView
        
        runBtn = UIBarButtonItem(title: "运行", style: UIBarButtonItemStyle.Plain, target: self, action: "run")
        navigationItem.rightBarButtonItem = self.runBtn
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
