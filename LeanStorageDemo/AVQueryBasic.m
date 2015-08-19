//
//  AVQueryBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVQueryBasic.h"
#import "Student.h"

@implementation AVQueryBasic

-(void)demoByClassNameQuery{
    AVQuery *query=[Student query];
    //限制查询返回数
    [query setLimit:3];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果: \n%@", objects];
        }
    }];
}

-(void)demoByGeoQuery{
    AVQuery *query=[Student query];
    //我们要找这个点附近的Student
    AVGeoPoint *geo=[AVGeoPoint geoPointWithLatitude:31.9 longitude:114.78];
    [query whereKey:@"location" nearGeoPoint:geo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%@", [objects description]]];
        }
    }];
}

-(void)demoOnlyGetQueryResultCount{
    AVQuery *query=[Student query];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if ([self  filterError:error]) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%ld个Student", (long)number]];
        }
    }];
}

- (void)demoLastModifyEnabled {
    // 放在 AppDelegate 较好
    [AVOSCloud setLastModifyEnabled:YES];
    
    [self createStudentForDemo:^(Student *student) {
        AVQuery *query = [Student query];
        // 此次应该走了网络
        [query getObjectInBackgroundWithId:student.objectId block:^(AVObject *object, NSError *error) {
            if ([self filterError:error]) {
                // 客户端把该对象的 udpatedAt 传给服务器，服务器判断对象未改变，于是返回 304 和空数据，客户端返回本地缓存的数据，节省流量
                [query getObjectInBackgroundWithId:student.objectId block:^(AVObject *object, NSError *error) {
                    if ([self filterError:error]) {
                        [self log:@"从缓存中获得数据：%@", object];
                    }
                }];
            }
        }];
    }];
}

- (void)demoLastModifyEnabled2 {
    // 放在 AppDelegate 较好，建议开启，节省流量
    [AVOSCloud setLastModifyEnabled:YES];
    
    AVQuery *query = [Student query];
    query.limit = 5;
    // 从网络获取了数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            // 服务器记录表的修改时间，如果两次查询之间表未被修改，则以下查询将从本地缓存获取数据
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"从本地缓存中获得数据：%@", objects];
                }
            }];
        }
    }];
}

- (void)demoQueryPolicyCacheThenNetwork_ {
    AVQuery *query = [Student query];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    query.maxCacheAge= 60 * 60; // 单位秒
    query.limit = 1;
    __block NSInteger count = 0;
    if ([query hasCachedResult]) {
        [self log:@"查询前有缓存"];
    } else {
        [self log:@"查询前无缓存"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (count == 0) {
            [self log:@"第一次从缓存中获取结果：%@", objects];
        } else {
            [self log:@"第二次从网络获取结果：%@", objects];
            [query clearCachedResult];
            [self log:@"为了演示，清除了查询缓存"];
        }
        count ++;
    }];
}

- (void)demoQueryPolicyCacheElseNetwork_ {
    AVQuery *query = [Student query];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    query.maxCacheAge= 60 * 60; // 单位秒
    query.limit = 6;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，将从缓存中获取结果"];
    } else {
        [self log:@"无缓存，将从网络获取结果"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyNetworkElseCache_ {
    AVQuery *query = [Student query];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge= 60 * 60; // 单位秒
    query.limit = 4;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，无网络时将从缓存获取结果"];
    } else {
        [self log:@"无缓存，有网络则从网络获取结果，否则将失败"];
    }
    // 运行过一次后可以关闭网络来看看是否从缓存中获取结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyNetworkOnly_ {
    AVQuery *query = [Student query];
    // 跟默认 IngoreCache 策略不同的是此策略会记录缓存
    query.cachePolicy = kAVCachePolicyNetworkOnly;
    query.maxCacheAge= 60 * 60; // 单位秒
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从网络获取了结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyCacheOnly_ {
    AVQuery *query = [Student query];
    query.cachePolicy = kAVCachePolicyCacheOnly;
    query.maxCacheAge= 60 * 60; // 单位秒
    query.limit = 2;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，将从缓存中获取"];
    } else {
        [self log:@"无缓存，将失败"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从缓存中获取了结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyIgnoreCache_ {
    AVQuery *query = [Student query];
    // 默认策略，不用设置也行，查询结果将不记录到本地
    query.cachePolicy = kAVCachePolicyIgnoreCache;
    query.limit = 2;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，但无视之"];
    } else {
        [self log:@"无缓存，也无视之"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"获取了结果：%@", objects];
        }
    }];
}

- (void)demoClearAllCache {
    [AVQuery clearAllCachedResults];
    [self log:@"已清除所有的缓存结果"];
}

MakeSourcePath
@end
