//
//  Post.m
//  LeanStorageDemo
//
//  Created by lzw on 15/8/19.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic content;
@dynamic author;
@dynamic likes;

+ (NSString *)parseClassName {
    return @"Post";
}

@end
