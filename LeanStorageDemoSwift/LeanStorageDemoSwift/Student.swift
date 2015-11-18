//
//  Student.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/3.
//  Copyright (c) 2015年 LeanCloud All rights reserved.
//

import UIKit
import AVOSCloud

let kStudentKeyHobbies: String = "hobbies"
let kStudnetKeyAvatar: String = "avatar"
let kStudnetKeyAge: String = "age"
let kStudentKeyAny: String = "any"
let kStudentKeyName: String = "name"
let kStudnetKeyFriends: String = "friends"

class Student: AVObject, AVSubclassing {
    
    @NSManaged var avatar: AVFile?
    
    @NSManaged var name: String?
    
    @NSManaged var age: Int32
    
    @NSManaged var hobbies: [String]?
    
    @NSManaged var any: AnyObject?
    
    static func parseClassName() -> String! {
        return "Student"
    }
}
