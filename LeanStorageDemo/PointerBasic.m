//
//  PointerBasic.m
//  LeanStorageDemo
//
//  Created by lzw on 15/8/19.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "PointerBasic.h"
#import "Student.h"
#import "Post.h"

@implementation PointerBasic

- (void)demoRelateObject {
    [self createStudentForDemo:^(Student *student) {
        Post *post = [Post object];
        post.content = @"每个 iOS 程序员必备的 8 个开发工具";
        post.author = student;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"把 Student 对象绑定到了 Post 对象的 author 字段！post: %@", post];
            }
        }];
    }];
}

- (void)demoObjectArray {
    [self createStudentForDemo:^(Student *student1) {
        [self createStudentForDemo:^(Student *student2) {
            // 发一条微博供示例用
            Post *post = [Post object];
            post.content = @"每个 iOS 程序员必备的 8 个开发工具";
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    // 两个人点赞了
                    [post addObject:student1 forKey:kPostKeyLikes];
                    [post addObject:student2 forKey:kPostKeyLikes];
                    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if ([self filterError:error]) {
                            [self log:@"用了 Object Array 来保存 Post 的点赞列表！Post : %@", post];
                        }
                    }];
                }
            }];
        }];
    }];
}

- (void)demoNotIncludeObject {
    AVQuery *query = [Post query];
    // 默认不包含 likes 字段的具体数据
    [query whereKey:kPostKeyLikes sizeEqualTo:2];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if ([self filterError:error]) {
            Post *post = (Post *)object;
            [self log:@"Post.likes = %@", post.likes];
        }
    }];
}

- (void)demoIncludeObject {
    AVQuery *query = [Post query];
    // 让返回结果包含了具体的数据，不单单是赞的人的 objectId
    [query includeKey:kPostKeyLikes];
    [query whereKey:kPostKeyLikes sizeEqualTo:2];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if ([self filterError:error]) {
            Post *post = (Post *)object;
            [self log:@"找回了 Post 及其 likes 字段下的 Object Array :%@", post.likes];
        }
    }];
}

MakeSourcePath

@end
