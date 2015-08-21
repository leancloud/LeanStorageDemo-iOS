//
//  EngineBasic.m
//  LeanStorageDemo
//
//  Created by lzw on 15/8/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "EngineBasic.h"

/*!
 *  云引擎与 SDK 的交互，需要结合云引擎项目学习 https://github.com/leancloud/sdk-demo-engine/blob/master/cloud.js
 */
@implementation EngineBasic

- (void)demoCallCloudFunction {
    [AVCloud callFunctionInBackground:@"hello" withParameters:nil block:^(id object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"云引擎返回结果：%@", object];
        }
    }];
}

- (void)demoErrorCode_ {
    [AVCloud callFunctionInBackground:@"errorCode" withParameters:nil block:^(id object, NSError *error) {
        if (!object && error && error.code == 211) {
            [self log:@"云引擎返回的 Error ：%@", error];
        }
    }];
}

- (void)demoCustomErrorCode_ {
    NSError *error;
    id response = [AVCloud callFunction:@"customErrorCode" withParameters:nil error:&error];
    if (!response && error && error.code == 123) {
        [self log:@"云引擎返回的 Error ：%@", error];
    }
}

-(void)demoFetchObject {
    [self createStudentForDemo:^(Student *student) {
        Student *fetchStudent = [Student objectWithoutDataWithClassName:student.className objectId:student.objectId];
        NSDictionary *params=@{@"obj":fetchStudent};
        [AVCloud callFunctionInBackground:@"fetchObject" withParameters:params block:^(id object, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"云引擎返回的结果：%@", object];
                [fetchStudent objectFromDictionary:object];
                
                [self log:@"根据返回结果构造的对象：%@", fetchStudent];
            }
        }];
    }];
}

-(void)demoFetchFullObject {
    [AVCloud callFunctionInBackground:@"fullObject" withParameters:nil block:^(id object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从云引擎中获取整个对象：%@", object];
        }
    }];
}

- (void)demoBeforeSave {
    AVObject *object = [AVObject objectWithClassName:@"AVCloudTest"];
    object[@"string"] = @"This is too much long, too much long, too long";
    object.fetchWhenSave = YES; // 保存的时候也获取最新属性
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"通过 beforeSave Hook 截断至 10个字符：%@", object[@"string"]];
        }
    }];
}

MakeSourcePath

@end
