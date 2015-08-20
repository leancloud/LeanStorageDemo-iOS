//
//  CQLBasic.m
//  LeanStorageDemo
//
//  Created by lzw on 15/6/7.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

// https://leancloud.cn/docs/cql_guide.html

#import "CQLBasic.h"

@implementation CQLBasic

- (void)demoSelect {
    NSString *cql = [NSString stringWithFormat:@"select * from %@", @"_User"];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
    [self log:@"%@ \n%@", cql, result.results];
}

- (void)democount {
    NSString *cql = [NSString stringWithFormat:@"select count(*) from %@", @"_User"];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
    [self log:@"%@\n%lu", cql, (unsigned long)result.count];
}

- (void)demoSelectWhere {
    NSString *cql = [NSString stringWithFormat:@"select objectId,createdAt from %@ where username=?", @"_User"];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql pvalues:@[@"XiaoMing"] error:nil];
    [self log:@"%@ \n %@", cql, result.results];
}

- (void)demoSelectWhereIn {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where username in (?, ?) ", @"_User"];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:@[@"XiaoMing", @"lzwjava@gmail.com"] callback:^(AVCloudQueryResult *result, NSError *error) {
        if ([self filterError:error]) {
            [self log:cql];
            for (AVUser * user in result.results) {
                [self log:@"%@", user.username];
            }
        }
    }];
}

- (void)demoSelectWhereDate {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where createdAt < date(?) order by -createdAt limit ?", @"_User"];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:@[@"2015-05-01T00:00:00.0000Z", @3] callback:^(AVCloudQueryResult *result, NSError *error) {
        if ([self filterError:error]) {
            [self log:cql];
            for (AVUser * user in result.results) {
                [self log:@"%@", user.createdAt];
            }
        }
    }];
}

- (void)demoSelectOrder {
    NSString *cql = [NSString stringWithFormat:@"select * from %@ order by -createdAt limit ?", @"_User"];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql pvalues:@[@5] callback:^(AVCloudQueryResult *result, NSError *error) {
        if ([self filterError:error]) {
            [self log:cql];
            for (AVUser * user in result.results) {
                [self log:@"%@", user.createdAt];
            }
        }
    }];
}


MakeSourcePath

@end
