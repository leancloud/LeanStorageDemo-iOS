//
//  AVUserDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit
import AVOSCloud

class AVUserDemo: Demo {
    var testUsername: String!
    var testPassword: String!
    
    required init() {
        super.init()
        testUsername = "Swift"
        testPassword = "password"
    }

    func logUnLogin (){
        log("未有用户登录，请先运行用户登录的示例")
    }
    
    func demoCurrentUser() {
        let user = AVUser.currentUser()
        if user != nil {
            log("当前用户:%@", user)
        } else {
            logUnLogin()
        }
    }
    
    func demoRegisterUser() {
        let user = AVUser()
        user.username = testUsername
        user.password = testPassword
        var error: NSError?
        do {
            try user.signUp()
        } catch let error1 as NSError {
            error = error1
        }
        if (filterError(error)) {
            log("已注册用户:%@", user)
        }
        logThreadTips()
    }
    
    func demoLogin() {
        var error : NSError?
        var user: AVUser!
        do {
            user = try AVUser.logInWithUsername(testUsername, password: testPassword)
        } catch let error1 as NSError {
            error = error1
            user = nil
        }
        if (filterError(error)) {
            log("登录成功, user:%@", user)
        }
    }
    
    func demoLogout() {
        AVUser.logOut();
        log("注销成功");
    }
    
    func demoDeleteUser() {
        let user = AVUser.currentUser()
        if user != nil {
            user.delete()
            log("删除用户成功：%@",user)
            

        } else {
            logUnLogin()
        }
    }
    
    func demoOldPasswordUpdatePassword() {
        if let user = AVUser.currentUser() {
            user.updatePassword(testPassword, newPassword: "111111", block: { (object :AnyObject!, error:NSError!) -> Void in
                if self.filterError(error) {
                    self.log("密码重置成功，新密码为 111111，user:%@", object.description)
                }
            })
        } else {
            logUnLogin()
        }
    }
    
    func demoEmailRegister() {
        alertViewHelper.showInputView("请输入您的邮箱来注册", block: { (email) -> Void in
            let user: AVUser = AVUser()
            user.username = email
            user.password = self.testPassword
            user.email = email
            user["gender"] = "男"
            user.signUpInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.log("用户注册成功 \(user)")
                    let user: AVUser = AVUser.currentUser()
                    self.log("当前用户 \(user.username)  邮箱 \(user.email)")
                    self.log("请检查邮箱进行验证。")
                }
            })
        })
    }
    
    func demoEmailLogin() {
        alertViewHelper.showInputView("请输入您的邮箱来登录", block: { (email) -> Void in
            AVUser.logInWithUsernameInBackground(email, password: self.testPassword, block: {(user: AVUser?, error: NSError?) in
                if self.filterError(error) {
                    self.log("登录成功 \(user)")
                }
            })
        })
    }
    
    func demoEmailResetPassword() {
        alertViewHelper.showInputView("请输入您的邮箱进行重置密码", block: { (email) -> Void in
            AVUser.requestPasswordResetForEmailInBackground(email, block: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.log("重置密码的连接已经发送到用户邮箱 \(email)")
                }
            })
        })
    }
    
    func randomString(length: Int) -> String{
        let charSet = "abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charSetN = charSet.characters.count
        var result = ""
        for i in 0 ..< length {
            result.append(charSet[charSet.startIndex.advancedBy(random() % charSetN)])
        }
        return result
    }
    
    func demoPhoneNumberRegisterUser() {
        alertViewHelper.showInputView("请输入手机号码来注册", block: { (phoneNumber) -> Void in
            let user = AVUser()
            user.username = self.randomString(6)
            user.password = self.testPassword
            user.mobilePhoneNumber = phoneNumber
            user.signUpInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.alertViewHelper.showInputView("验证短信已发送，请输入验证码", block: { (smsCode) -> Void in
                        AVUser.verifyMobilePhone(smsCode, withBlock: {(succeeded: Bool, error: NSError?) in
                            if self.filterError(error) {
                                self.log("成功注册  手机号 \(phoneNumber) 密码 \(self.testPassword)")
                            }
                        })
                    })
                }
            })
        })
    }
    
    func demoPhoneNumberAndPasswordLogin() {
        alertViewHelper.showInputView("请输入手机号码来登录", block: { (phoneNumber) -> Void in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, password: self.testPassword, block: {(user: AVUser?, error: NSError?) in
                if self.filterError(error) {
                    self.log("成功登录 用户为 \(user)")
                }
            })
        })
    }
    
    func demoPhoneNumberAndCodeLogin() {
        alertViewHelper.showInputView("请输入手机号码来登录", block: { (phoneNumber) -> Void in
            AVUser.requestLoginSmsCode(phoneNumber, withBlock: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.alertViewHelper.showInputView("验证码已发送，请输入验证码", block: { (smsCode) -> Void in
                        AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: {(user: AVUser?, error: NSError?) in
                            if self.filterError(error) {
                                self.log("成功登录 用户为\(user)")
                            }
                        })
                    })
                }
            })
        })
    }
    
    func demoPhoneNumberResetPassword() {
        alertViewHelper.showInputView("请输入需要重置密码的手机号", block: { (phoneNumber) -> Void in
            AVUser.requestPasswordResetWithPhoneNumber(phoneNumber, block: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.alertViewHelper.showInputView("短信已发送，请输入验证码来重置密码", block: { (smsCode) -> Void in
                        let newPassword = "111111"
                        AVUser.resetPasswordWithSmsCode(smsCode, newPassword: newPassword, block: {(succeeded: Bool, error: NSError?) in
                            if self.filterError(error) {
                                self.log("密码重置成功，新密码为 \(newPassword)")
                            }
                        })
                    })
                }
            })
        })
    }
    
    func demoPhoneNumberRegisterOrLogin() {
        alertViewHelper.showInputView("请输入手机号来注册或登录", block: { (phoneNumber) -> Void in
            AVOSCloud.requestSmsCodeWithPhoneNumber(phoneNumber, callback: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.alertViewHelper.showInputView("验证码已发送，请输入验证码", block: { (smsCode) -> Void in
                        AVUser.signUpOrLoginWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: {(user: AVUser?, error: NSError?) in
                            if self.filterError(error) {
                                self.log("注册或登录成功 phone:\(phoneNumber)\nuser:\(user)")
                            }
                        })
                    })
                }
            })
        })
    }
    
    func demoAnonymousUserLogin() {
        AVAnonymousUtils.logInWithBlock({(user: AVUser?, error: NSError?) in
            if self.filterError(error) {
                self.log("匿名用户登录成功，user : \(user!) \n username : \(user!.username)")
            }
        })
    }
}
