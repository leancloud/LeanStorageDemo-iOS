//
//  Post.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/3.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit
import AVOSCloud

let kPostKeyLikes = "likes"
let kPostKeyAuthor = "author"

class Post: AVObject, AVSubclassing {
    
    @NSManaged var content: NSString?
    
    @NSManaged var author: Student?
    
    @NSManaged var likes: [AnyObject]?
    
    static func parseClassName() -> String! {
        return "Post"
    }
}
