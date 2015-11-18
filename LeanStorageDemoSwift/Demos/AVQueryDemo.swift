//
//  AVQueryDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit
import AVOSCloud

class AVQueryDemo: Demo {
    func demoBasicQuery() {
        let q = Student.query()
        let students = q.findObjects()
        log("找回了一组学生:%@", students)
    }
    
    func demoGetFirst() {
        let q = Student.query()
        let student = q.getFirstObject()
        log("找回了第一个学生:%@", student)
    }
    
    func demoLimit() {
        let q = Student.query()
        q.limit = 5
        let students = q.findObjects()
        log("找回了五个学生:%@", students)
    }
    
    func demoSkip() {
        let q = Student.query()
        q.orderByAscending("createdAt")
        q.skip = 3
        let student = q.getFirstObject()
        log("找回了第三个创建的学生:%@", student)
    }
    
    func demoBasicFind() {
        let query = Post.query()
        query.whereKey(kPostKeyAuthor, equalTo: getFirstStudent())
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("找回 \(objects?.count) 个 Post:\n")
                for post in objects as! [Post] {
                    self.log("author:\(post.author) content:\(post.content)");
                }
            }
        })
    }

    func demoAndQuery() {
        let query1: AVQuery = Student.query()
        query1.whereKey(kStudentKeyName, notEqualTo: "Mike")
        let query2: AVQuery = Student.query()
        query2.whereKey(kStudentKeyName, hasPrefix: "M")
        let query: AVQuery = AVQuery.andQueryWithSubqueries([query1, query2])
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("名字不为 Mike 且 M 开头的学生：\(objects)")
            }
        })
    }
    
    func demoOrQuery() {
        let query1: AVQuery = Student.query()
        query1.whereKey(kStudentKeyName, equalTo: "Mike")
        let query2: AVQuery = Student.query()
        query2.whereKey(kStudentKeyName, hasPrefix: "J")
        let query: AVQuery = AVQuery.orQueryWithSubqueries([query1, query2])
        query.countObjectsInBackgroundWithBlock({(number: Int, error: NSError?) in
            if self.filterError(error) {
                self.log("名字为 Mike 或 J 开头的学生有 \(number) 个")
            }
        })
    }
    
    func demoByKeyOrder() {
        let query: AVQuery = Student.query()
        query.orderByDescending(kStudnetKeyAge)
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("年龄从大到小排序的学生：\(objects)")
            }
        })
    }
    
    func demoAddSecondOrder() {
        let query: AVQuery = Student.query()
        query.orderByDescending(kStudnetKeyAge)
        query.addDescendingOrder(kStudentKeyName)
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("先按年龄从大到小排，再按名字排序，结果为：\(objects)")
            }
        })
    }
    
    func demoBySortDescriptorsOrder() {
        let query: AVQuery = Student.query()
        query.orderBySortDescriptors([NSSortDescriptor(key: kStudnetKeyAge, ascending: false), NSSortDescriptor(key: kStudentKeyName, ascending: true)])
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("先按年龄从大到小排，再按名字排序，结果为：\(objects)")
            }
        })
    }
    
    func demoByArraySizeQuery() {
        let query: AVQuery = Student.query()
        query.whereKey(kStudentKeyHobbies, sizeEqualTo: 1)
        query.limit = 4
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("爱好有一个的学生：\(objects)")
            }
        })
    }
    
    func demoContainedIn() {
        let query: AVQuery = Student.query()
        query.whereKey(kStudentKeyName, containedIn: ["Mike", "Jane"])
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("名字为 Mike 或 Jane 的学生：\(objects)")
            }
        })
    }
    
    func demoContainObjectsInArray() {
        let query: AVQuery = Student.query()
        query.whereKey(kStudentKeyHobbies, containsAllObjectsInArray: ["swimming", "running"])
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("爱好有 swimming 和 running 的学生：\(objects)")
            }
        })
    }
    
    func demoLimitResultCount() {
        let query: AVQuery = Student.query()
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("仅查找五个学生：\(objects)")
            }
        })
    }
    
    func demoRegex() {
        let query: AVQuery = Student.query()
        let regex = "^M.*"
        query.whereKey(kStudentKeyName, matchesRegex: regex)
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("名字满足正则表达式 \(regex) 的学生：\(objects)")
            }
        })
    }
    
    func demoOneKeyMultipleCondition() {
        let query: AVQuery = Student.query()
        query.whereKey(kStudentKeyName, hasPrefix: "M")
        query.whereKey(kStudentKeyName, hasSuffix: "e")
        query.whereKey(kStudentKeyName, containsString: "i")
        query.limit = 3
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("名字有前缀 M 和后缀 e且包含字符 i 的学生：\(objects)")
            }
        })
    }
    
    func demoQueryEqualToObject() {
        let student = getFirstStudent();
        let query: AVQuery = Post.query()
        query.whereKey(kPostKeyAuthor, equalTo: student)
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("找到第一个学生发的微博：\(objects)")
            }
        })
    }
    
    func demoMatchesInSubquery() {
        let query: AVQuery = Student.query()
        query.orderByDescending("createdAt")
        query.limit = 50
        let postQuery: AVQuery = Post.query()
        postQuery.whereKey(kPostKeyAuthor, matchesQuery: query)
        postQuery.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("最近创建的50个学生的微博：\(objects)")
            }
        })
    }
    
    func demoDoesNotMatchesInSubquery() {
        let query: AVQuery = Student.query()
        query.orderByDescending("createdAt")
        query.limit = 50
        let postQuery: AVQuery = Post.query()
        postQuery.whereKey(kPostKeyAuthor, doesNotMatchQuery: query)
        postQuery.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("除去最近50个学生创建的微博：\(objects)")
            }
        })
    }
    
    func demoLastModifyEnabled() {
        AVOSCloud.setLastModifyEnabled(true)
        let student = getFirstStudent()
        let query: AVQuery = Student.query()
        query.getObjectInBackgroundWithId(student.objectId, block: {(object: AVObject?, error: NSError?) in
            if self.filterError(error) {
                query.getObjectInBackgroundWithId(student.objectId, block: {(object: AVObject?, error: NSError?) in
                    if self.filterError(error) {
                        self.log("从缓存中获得数据：\(object)")
                    }
                })
            }
        })
    }
    
    func demoLastModifyEnabled2() {
        AVOSCloud.setLastModifyEnabled(true)
        let query: AVQuery = Student.query()
        query.limit = 5
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
                    if self.filterError(error) {
                        self.log("从本地缓存中获得数据：\(objects)")
                    }
                })
            }
        })
    }
    
    func demoQueryPolicyCacheThenNetwork() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.CacheThenNetwork
        query.maxCacheAge = 60 * 60
        query.limit = 1
        var count: Int = 0
        if query.hasCachedResult() {
            self.log("查询前有缓存")
        } else {
            self.log("查询前无缓存")
        }
        
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if count == 0 {
                self.log("第一次从缓存中获取结果：\(objects)")
            } else {
                self.log("第二次从网络获取结果：\(objects)")
                query.clearCachedResult()
                self.log("为了演示，清除了查询缓存")
            }
            count++
        })
    }
    
    func demoQueryPolicyCacheElseNetwork() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.CacheElseNetwork
        query.maxCacheAge = 60 * 60
        query.limit = 6
        if query.hasCachedResult() {
            self.log("有缓存，将从缓存中获取结果")
        } else {
            self.log("无缓存，将从网络获取结果")
        }
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("查询结果：\(objects)")
            }
        })
    }
    
    func demoQueryPolicyNetworkElseCache() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.NetworkElseCache
        query.maxCacheAge = 60 * 60
        query.limit = 4
        if query.hasCachedResult() {
            self.log("有缓存，无网络时将从缓存获取结果")
        } else {
            self.log("无缓存，有网络则从网络获取结果，否则将失败")
        }
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("查询结果：\(objects)")
            }
        })
    }
    
    func demoQueryPolicyNetworkOnly() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.NetworkOnly
        query.maxCacheAge = 60 * 60
        query.limit = 3
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("从网络获取了结果：\(objects)")
            }
        })
    }
    
    func demoQueryPolicyCacheOnly() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.CacheOnly
        query.maxCacheAge = 60 * 60
        query.limit = 2
        if query.hasCachedResult() {
            self.log("有缓存，将从缓存中获取")
        } else {
            self.log("无缓存，将失败")
        }
        
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("从缓存中获取了结果：\(objects)")
            }
        })
    }
    
    func demoQueryPolicyIgnoreCache() {
        let query: AVQuery = Student.query()
        query.cachePolicy = AVCachePolicy.IgnoreCache
        query.limit = 2
        if query.hasCachedResult() {
            self.log("有缓存，但无视之")
        } else {
            self.log("无缓存，也无视之")
        }
        
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]?, error: NSError?) in
            if self.filterError(error) {
                self.log("获取了结果：\(objects)")
            }
        })
    }
    
    func demoClearAllCache() {
        AVQuery.clearAllCachedResults()
        self.log("已清除所有的缓存结果")
    }
}
