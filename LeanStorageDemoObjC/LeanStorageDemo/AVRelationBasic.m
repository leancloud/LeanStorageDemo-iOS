//
//  AVRelationAdvanced.m
//  AVOSDemo
//
//  Created by Travis on 13-12-19.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVRelationBasic.h"
#import "Student.h"

// 大多数 Array 的限制条件也可以作用于 Relation，如 whereKey:sizeEqualTo
@implementation AVRelationBasic

-(void)demoAddRelation{
    //假设有2个Student xiaoQiang和xiaoHong
    //把这两个人关联xiaoGang的好友
    
    Student *xiaoQiang=[Student object];
    xiaoQiang.name=@"XiaoQiang";
    //save是同步的保存方法, 会卡住线程, 这里为了方便理解才使用. 正常情况请尽量使用异步方法,比如saveInBackground等
    [xiaoQiang save];
    
    Student *xiaoHong=[Student object];
    xiaoHong.name=@"XiaoHong";
    [xiaoHong save];
    
    
    Student *xiaoGang=[Student object];
    xiaoGang.name=@"XiaoGang";
    
    
    //获取Relation属性
    AVRelation *friends= [xiaoGang relationforKey:@"friends"];
    
    [friends addObject:xiaoQiang];
    [friends addObject:xiaoHong];
    
    //保存
    [xiaoGang saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"关联成功 %@",xiaoGang]];
        }
    }];
}

-(void)demoGetRelationMember{
    AVQuery *query = [Student query];
    [query whereKey:kStudentKeyName equalTo:@"XiaoGang"];
    Student *xiaoGang = (Student *)[query getFirstObject];
    if (xiaoGang == nil) {
        [self log:@"请先运行第一个创建关联的示例"];
        return;
    }
    
    //这是AVObject的另一个获取数据的用法, 只有在数据不存在时进行网络请求
    [xiaoGang fetchIfNeeded];
    //获取Relation属性
    AVRelation *friends= [xiaoGang relationforKey:@"friends"];
    [[friends query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"关联获取成功 %@", objects];
        }
    }];
}

- (Student *)getStudentWithFriends{
    AVQuery *query = [Student query];
    [query whereKey:kStudentKeyName equalTo:@"XiaoGang"];
    [query whereKey:kStudnetKeyFriends sizeEqualTo:2];
    [query orderByDescending:@"createdAt"];
    Student *xiaoGang = (Student *)[query getFirstObject];
    if (xiaoGang == nil) {
        [self log:@"请先运行第一个创建关联的示例"];
    }
    return xiaoGang;
}

-(void)demoDeleteRelationMember{
    Student *xiaoGang = [self getStudentWithFriends];
    AVRelation *friends = [xiaoGang relationforKey:kStudnetKeyFriends];
    AVQuery *friendsQuery = [friends query];
    NSArray *array = [friendsQuery findObjects];
    if (array.count == 0) {
        [self log:@"请先运行第一个创建关联的示例"];
        return;
    }
    Student *student = array[0];
    
    [friends removeObject:student];
    [self log:@"删除关系前 friends: %@", array];
    [xiaoGang saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self log:@"关联删除之后 friends: %@",objects];
            }];
        }
    }];
}

- (void)demoRelationCount {
    Student *xiaoGang = [self getStudentWithFriends];
    AVRelation *friends = [xiaoGang relationforKey:kStudnetKeyFriends];
    AVQuery *friendsQuery = [friends query];
    [friendsQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"friends relation count: %ld", number];
        }
    }];
}

- (void)demoRelationReverseQuery {
    AVQuery *query = [Student query];
    [query orderByDescending:@"createdAt"];
    [query whereKey:kStudentKeyName equalTo:@"XiaoHong"];
    Student *xiaoHong = (Student *)[query getFirstObject];
    if (xiaoHong == nil) {
        [self log:@"请先运行第一个示例"];
        return;
    }
    AVQuery *reverseQuery = [AVRelation reverseQuery:xiaoHong.className relationKey:kStudnetKeyFriends childObject:xiaoHong];
    [reverseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            if (objects.count) {
                [self log:@"找到朋友中有 XiaoHong 的学生 %@", objects];
            } else {
                [self log:@"请先运行第一个示例"];
            }
        }
    }];
}

MakeSourcePath
@end
