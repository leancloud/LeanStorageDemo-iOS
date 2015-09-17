//
//  AVObjectDemo.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit
import AVOSCloud

class AVObjectDemo: Demo {
    
    func demoCreateObject() {
        var student = Student()
        student.name = "Mike"
        student.age = 12
        student.save()
        log("创建成功:%@", student)
        logThreadTips()
    }
    
    func demoUpdateObject() {
        var student = getFirstStudent()
        log("更改名字前的对象:%@", student)
        student.setObject("Jane", forKey: kStudentKeyName)
        student.save()
        log("更改名字后的对象:%@", student)
    }
    
    func demoDeleteObject() {
        var student = getFirstStudent()
        student.delete()
        log("删除了对象:%@", student)
    }
    
    func demoFetchObject() {
        var student = getFirstStudent()
        var objectId = student.objectId
        
        var fetchStudent = Student(withoutDataWithObjectId: objectId)
        fetchStudent.fetch()
        log("获取了对象:%@", fetchStudent)
    }
    
    func demoCreateObjectAndFile() {
        var student: Student = Student()
        student.name = "Mike"
        var avatar: AVFile = AVFile(name: "cloud.png", contentsAtPath: NSBundle.mainBundle().pathForResource("cloud", ofType: "png"));
        student.avatar = avatar
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("保存对象与文件成功。 student : \(student)")
            }
        })
    }
    
    func demoFromDictionaryCreateObject() {
        var json: NSString = "{\"result\":[{\"gender\":true,\"profileThumbnail\":{\"__type\":\"File\",\"id\":\"5416e87fe4b0f645f29e15cd\",\"name\":\"ugQgIhsiRCBmAyUXPiJBIXvMEQHmq2zoRV6RVabF\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/4nTUcDbKVGDZymrd\"},\"profilePicture\":{\"__type\":\"File\",\"id\":\"5416e877e4b0f645f29e15b6\",\"name\":\"fdrWE627VCPGB8pi1p343XiYk3f2m93mEtU3IvLD\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/eyeFsPgmhxlaPfK8\"},\"activeness\":0,\"nickName\":\"璇璇\",\"likedCount\":750,\"pickiness\":0.15086206896551724,\"username\":\"18588888888\",\"viewedCount\":962,\"viewCount\":232,\"mobilePhoneVerified\":false,\"nearestOnline\":0,\"peerId\":\"18588888888\",\"importFromParse\":false,\"emailVerified\":false,\"signature\":\"~大家好~!希望在钟情交到一些朋友!喜欢我的话就赞我吧！\",\"likeCount\":35,\"recommendIndex\":0.6376030539823643,\"postCount\":3,\"hotness\":0.7796257796257796,\"meetedUser\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"playlistRel\":{\"__type\":\"Relation\",\"className\":\"Playlist\"},\"lastOnlineDate\":{\"__type\":\"Date\",\"iso\":\"2014-10-01T03:55:28.163Z\"},\"birthday\":{\"__type\":\"Date\",\"iso\":\"1991-03-15T13:22:12.000Z\"},\"post0\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/k4TO50kRytl2YTAR.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"QOoUkunpDf8LwRAegol7M07Pia3p8umgBSJtsXqn\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/Gu6uLsGds6FqKnWJ\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"5412c79be4b080380a4895b6\",\"createdAt\":\"2014-09-12T10:14:51.102Z\",\"updatedAt\":\"2014-09-12T10:14:51.108Z\"},\"post1\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/aNm5STA2uuVAXrJi.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"CtGjAUT1JoKo9JI5CL0xWMsm0NVjjU0CWL9UO4DB\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/GPWno3YM2L6D08ub\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"541934ece4b013b181daab26\",\"createdAt\":\"2014-09-17T07:14:52.461Z\",\"updatedAt\":\"2014-09-17T07:14:52.473Z\"},\"post2\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/KwsYBMOzyGXZGzDU.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"lUNfftRFnu2xJ7IONu1wAoMtAQFEERTADkLmKST7\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/YOR7l2ws58DlJYiG\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"5419a7d2e4b0002e6997c743\",\"createdAt\":\"2014-09-17T15:25:06.765Z\",\"updatedAt\":\"2014-09-17T15:25:06.782Z\"},\"objectId\":\"5416e880e4b0f645f29e15ce\",\"createdAt\":\"2014-09-15T13:24:16.128Z\",\"updatedAt\":\"2014-10-09T07:50:40.971Z\"}]}"
        var dict: [NSObject: AnyObject] = NSJSONSerialization.JSONObjectWithData((json.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [NSObject:AnyObject]
        var array = dict["result"] as! [AnyObject]
        var o: [NSObject: AnyObject] = array[0] as! [NSObject: AnyObject]
        var user: AVUser = AVUser()
        user.objectFromDictionary(o)
        self.log("从一大段文本创建了User对象，user:\(user)")
    }
    
    func demoWithDictionaryCreateObject() {
        var dict: [NSObject: AnyObject] = ["name": "Mike"]
        var student: Student = Student(className: Student.parseClassName(), dictionary: dict)
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("用字典赋值字段并保存成功！student:\(student)")
            }
        })
    }
    
    func demoOfflineCreateObject() {
        self.log("请在网络关闭时运行本方法，然后开启网络，看是否保存上")
        var object: AVObject = AVObject(className: "Student")
        object.setObject(NSStringFromSelector(__FUNCTION__), forKey: "name")
        object.saveEventually({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("离线保存完毕，请开启网络")
            }
        })
    }
    
    func demoCounter() {
        var student = getFirstStudent()
        student.fetchWhenSave = true
        student.incrementKey("age", byAmount: 1)
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("\(student.objectId) 过生日了 当前年龄为:\(student.age)")
            }
        })
    }
    
    func demoAnyType() {
        var student: Student = Student()
        student.any = 1
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("Student 的 any 列被保存为了数字: \(student)")
                student.any = "hello world"
                student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                    if self.filterError(error) {
                        self.log("Student 的 any 列被保存为了字符串：\(student)")
                        student.any = ["score": 100, "name": "kitty"]
                        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                            if self.filterError(error) {
                                self.log("Student 的 any 列被保存为了字典：\(student)")
                                self.log("结束")
                            }
                        })
                    }
                })
            }
        })
    }
    
    
    func demoGetAllKeys() {
        var student = getFirstStudent()
        self.log("对象的所有字段为：\(student.allKeys())")
    }
    
    func demoRemoveKey() {
        var student = getFirstStudent()
        self.log("移除前有字段：\(student.allKeys())")
        student.removeObjectForKey(kStudentKeyName)
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("移除后有字段：\(student.allKeys())")
            }
        })
    }
    
    func demoSubscriptingReadWrite() {
        var student: Student = Student()
        student[kStudentKeyName] = "subscript"
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("下标访问学生名字 :\(student[kStudentKeyName])")
            }
        })
    }
    
    func demoArrayAddObject() {
        var studentId = getFirstStudent().objectId
        var student: Student = Student(withoutDataWithObjectId: studentId)
        student.fetchInBackgroundWithBlock({(object: AVObject?, error: NSError?) in
            if self.filterError(error) {
                self.log("hobbis before : \(student.hobbies)")
                student.addObject("swimming", forKey: kStudentKeyHobbies)
                student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
                    if self.filterError(error) {
                        self.log("hobbis after: \(student.hobbies)")
                    }
                })
            }
        })
    }
    
    func demoArrayAddMultipleObject() {
        var student = getFirstStudent()
        self.log("添加前，student.hobbies = \(student.hobbies)")
        student.addObjectsFromArray(["table tennis", "fly"], forKey: kStudentKeyHobbies)
        self.log("将两个爱好添加到了爱好数组里")
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("添加后，student.hobbies = \(student.hobbies)")
            }
        })
    }
    
    func demoArrayRemoveObject() {
        var student = getFirstStudent()
        self.log("hobbis before : \(student.hobbies)")
        student.removeObject("swimming", forKey: kStudentKeyHobbies)
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("hobbis after: \(student.hobbies)")
            }
        })
    }
    
    func demoArrayAddUniqueObject() {
        var student = getFirstStudent()
        self.log("hobbis before : \(student.hobbies)")
        student.addUniqueObject("swimming", forKey: kStudentKeyHobbies)
        self.log("添加了唯一对象 swimming 到爱好数组中")
        student.saveInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("hobbis after: \(student.hobbies)")
            }
        })
    }
    
    func createStudentsForDemo(block: (students: [Student]) -> Void) {
        var students = [Student]()
        for i in 10..<20 {
            var student: Student = Student()
            student.age =  Int32(i)
            students.append(student)
        }
        AVObject.saveAllInBackground(students, block: {(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                block(students: students)
            }
        })
    }
    
    func demoBatchCreate() {
        var students = [Student]()
        for i in 10..<20 {
            var student: Student = Student()
            student.age =  Int32(i)
            students.append(student)
        }
        
        AVObject.saveAllInBackground(students, block: {(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("批量创建了10个学生！他们是：\(students)")
            }
        })
    }
    
    func demoBatchFetch() {
        self.createStudentsForDemo { (students) -> Void in
            var fetchStudents = [Student]()
            for student: Student in students {
                var fetchStudent: Student = Student(withoutDataWithObjectId: student.objectId)
                fetchStudents.append(fetchStudent)
            }
            
            AVObject.fetchAllIfNeededInBackground(fetchStudents, block: {(objects: [AnyObject]?, error: NSError?) in
                if self.filterError(error) {
                    self.log("批量获取了10个学生！他们是：\(fetchStudents)")
                }
            })
        }
    }
    
    func demoBatchUpdate() {
        self.createStudentsForDemo { (students) -> Void in
            for student: Student in students {
                student.name = "Mike"
            }
            AVObject.saveAllInBackground(students, block: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.log("批量更新了10个学生！他们是：\(students)")
                }
            })
        }
    }
    
    func demoBatchDelete() {
        createStudentsForDemo { (students) -> Void in
            AVObject.deleteAllInBackground(students, block: {(succeeded: Bool, error: NSError?) in
                if self.filterError(error) {
                    self.log("批量删除了10个学生！他们是：\(students)")
                }
            })
        }
    }
    
    func demoBatchCreateObjectAndFile() {
        var students = [Student]()
        for i in 10..<20 {
            var student: Student = Student()
            var avatar = AVFile(name: "avatar.jpg", contentsAtPath: NSBundle.mainBundle().pathForResource("alpacino.jpg", ofType: nil)!)
            student.age =  Int32(i)
            students.append(student)
        }
        AVObject.saveAllInBackground(students, block: {(succeeded: Bool, error: NSError?) in
            if self.filterError(error) {
                self.log("批量了保存了10个学生及其头像，他们是：\(students)")
            }
        })
    }

}
