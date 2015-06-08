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
        if (objects) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%@", [objects description]]];
        }else{
            [self log:[NSString stringWithFormat:@"查询出错: \n%@", [error description]]];
        }
    }];
}


-(void)demoOnlyGetQueryResultCount{
    AVQuery *query=[Student query];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error==nil) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%ld个Student", (long)number]];
        }else{
            [self log:[NSString stringWithFormat:@"查询出错: \n%@", [error description]]];
        }
    }];
}

MakeSourcePath
@end
