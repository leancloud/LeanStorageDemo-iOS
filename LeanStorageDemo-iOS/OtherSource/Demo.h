//
//  Demo.h
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LZAlertViewHelper/LZAlertViewHelper.h>

#define SourcePath [[NSBundle mainBundle] pathForResource:[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] ofType:nil inDirectory:@"SourceCode"]

#define MakeSourcePath -(NSString*)sourcePath{return SourcePath;}

@class DemoRunC;
@interface Demo : NSObject
@property(nonatomic,readonly) NSString *sourcePath;
@property(nonatomic,weak) UITextView *outputView;
@property(nonatomic,weak) DemoRunC *controller;
@property(nonatomic,strong) LZAlertViewHelper *alertViewHelper;
-(NSArray*)allDemoMethod;
- (void)log:(NSString *)format, ...;
-(BOOL)filterError:(NSError *)error;

- (void)showImage:(UIImage *)image;

@end
