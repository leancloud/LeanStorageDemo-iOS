//
//  Demo.h
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertViewHelper.h"
@class DemoRunC;
@interface Demo : NSObject
@property(nonatomic,readonly) NSString *sourcePath;
@property(nonatomic,weak) UITextView *outputView;
@property(nonatomic,weak) DemoRunC *controller;
@property(nonatomic,strong) AlertViewHelper *alertViewHelper;
-(NSArray*)allDemoMethod;

-(void)log:(NSString*)msg;

-(BOOL)filterError:(NSError *)error;

@end
