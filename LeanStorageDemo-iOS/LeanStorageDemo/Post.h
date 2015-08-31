//
//  Post.h
//  LeanStorageDemo
//
//  Created by lzw on 15/8/19.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

#define kPostKeyLikes @"likes"
#define kPostKeyAuthor @"author"
#define kPostKeyContent @"content";

@interface Post : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) Student *author;
@property (nonatomic, strong) NSArray *likes; //Student Array

@end
