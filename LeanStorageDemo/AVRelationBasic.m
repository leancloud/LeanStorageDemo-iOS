//
//  AVRelationAdvanced.m
//  AVOSDemo
//
//  Created by Travis on 13-12-19.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVRelationBasic.h"
#import "Student.h"

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
    //这里默认有个一直的Student的id: 55740e70e4b002b1c5dddd9a
    Student *xiaoGang=[Student objectWithoutDataWithObjectId:@"55740e70e4b002b1c5dddd9a"];
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

-(void)demoDeleteRelationMember{
    //这里默认有个一直的Student的id: 55740e70e4b002b1c5dddd9a
    Student *xiaoGang=[Student objectWithoutDataWithObjectId:@"55740e70e4b002b1c5dddd9a"];
    
    //这是AVObject的另一个获取数据的用法, 只获取某些熟悉
    [xiaoGang fetchIfNeededWithKeys:@[@"friends"]];
    
    
    //假设我们要删掉xiaoGang的这个朋友: 52b290bce4b0c95c1fa49ad7
    Student *xiaoHong=[Student objectWithoutDataWithObjectId:@"52b290b9e4b0c95c1fa49ad6"];
    
    //获取Relation属性
    AVRelation *friends= [xiaoGang relationforKey:@"friends"];
    [friends removeObject:xiaoHong];
    
    [xiaoGang saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"关联删除成功 %@",[xiaoGang description]]];
        }
    }];
}

MakeSourcePath
@end
