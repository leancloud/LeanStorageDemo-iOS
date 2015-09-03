//
//  AVUserDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class AVUserDemo: Demo {
    var testUsername: String!
    var testPassword: String!
    
    override init() {
        super.init()
        testUsername = "Swift"
        testPassword = "password"
    }

    func logUnLogin (){
        log("未有用户登录，请先运行用户登录的示例")
    }
    
    func demoCurrentUser() {
        var user = AVUser.currentUser()
        if user != nil {
            log("当前用户:%@", user)
        } else {
            logUnLogin()
        }
    }
    
    func demoRegisterUser() {
        var user = AVUser()
        user.username = testUsername
        user.password = testPassword
        var error: NSError?
        user.signUp(&error)
        if (filterError(error)) {
            log("已注册用户:%@", user)
        }
        logThreadTips()
    }
    
    func demoLogin() {
        var error : NSError?
        var user = AVUser.logInWithUsername(testUsername, password: testPassword, error: &error)
        if (filterError(error)) {
            log("登录成功, user:%@", user)
        }
    }
    
    func demoLogout() {
        AVUser.logOut();
        log("注销成功");
    }
    
    func demoDeleteUser() {
        var user = AVUser.currentUser()
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
    
}
