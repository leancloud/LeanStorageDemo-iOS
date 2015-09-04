//
//  OtherBasic.m
//  LeanStorageDemo
//
//  Created by lzw on 15/8/20.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "OtherBasic.h"

@implementation OtherBasic

- (void)demoGetServerDate {
    [AVOSCloud getServerDateWithBlock:^(NSDate *date, NSError *error) {
        [self log:@"服务器时间为：%@", date];
    }];
}

- (void)demoConfigNetworkTimeout {
    NSTimeInterval timerInterval = [AVOSCloud networkTimeoutInterval];
    [AVOSCloud setNetworkTimeoutInterval:0.01];
    [AVOSCloud getServerDateWithBlock:^(NSDate *date, NSError *error) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            [self log:@"因为设置了 0.01 秒超时，所以该请求超时了。"];
        } else {
            [self log:@"%@", error];
        }
        [AVOSCloud setNetworkTimeoutInterval:timerInterval];
    }];
}

MakeSourcePath

@end
