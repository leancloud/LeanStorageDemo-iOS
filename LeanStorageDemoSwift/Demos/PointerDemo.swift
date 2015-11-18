//
//  PointerDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit
import AVOSCloud

class PointerDemo: Demo {
    func demoRelateObject() {
        let student = getFirstStudent()
        
        let post: Post = Post()
        post.content = "每个 iOS 程序员必备的 8 个开发工具"
        post.author = student
        post.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("把 Student 对象绑定到了 Post 对象的 author 字段！post: \(post)")
            }
        })
    }
    
    func demoObjectArray() {
        let student1 = getFirstStudent()
        let student2 = getSecoundStudent()
        let post: Post = Post()
        post.content = "每个 iOS 程序员必备的 8 个开发工具"
        post.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                post.addObject(student1, forKey: kPostKeyLikes)
                post.addObject(student2, forKey: kPostKeyLikes)
                post.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                    if self.filterError(error) {
                        self.log("用了 Object Array 来保存 Post 的点赞列表！Post : \(post)")
                    }
                })
            }
        })
    }
    
    func demoNotIncludeObject() {
        let query: AVQuery = Post.query()
        query.whereKey(kPostKeyLikes, sizeEqualTo: 2)
        query.getFirstObjectInBackgroundWithBlock({(object: AVObject?, error: NSError?) in
            if self.filterError(error) {
                let post: Post = object as! Post
                self.log("Post.likes = \(post.likes)")
            }
        })
    }
    
    func demoIncludeObject() {
        let query: AVQuery = Post.query()
        query.includeKey(kPostKeyLikes)
        query.whereKey(kPostKeyLikes, sizeEqualTo: 2)
        query.getFirstObjectInBackgroundWithBlock({(object: AVObject?, error: NSError?) in
            if self.filterError(error) {
                let post: Post = object as! Post
                self.log("找回了 Post 及其 likes 字段下的 Object Array :\(post.likes)")
            }
        })
    }
    
}
