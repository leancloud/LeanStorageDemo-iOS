//
//  AlertViewHelper.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/3.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit

class AlertViewHelper:NSObject, UIAlertViewDelegate {
    
    var finishBlock: ((input:String?) -> Void)?
    
    func showInputView(message: String, block:(input:String?) -> Void) {
        finishBlock = block
        let alertView = UIAlertView(title: nil, message: message, delegate: self as UIAlertViewDelegate, cancelButtonTitle: "取消")
        alertView.addButtonWithTitle("确定")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if finishBlock != nil {
                finishBlock!(input:alertView.textFieldAtIndex(0)?.text)
            }
        }
    }
}
