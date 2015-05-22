//
//  AVAnalyticsBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-23.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVAnalyticsBasic.h"

@implementation AVAnalyticsBasic

/*
"Reverse"   ="冲正";
"Refund"    ="退货";
"Swip"      ="刷卡";
"Device"    ="刷卡器";
"Cups"      ="CUPS";
*/

- (void)logEvent:(NSString *)eventName {
    [self log:[NSString stringWithFormat:@"提交了事件： %@",eventName]];
}

-(void)demoAnalyticsDeviceError{
    NSString *event = @"刷卡器错误";
    [AVAnalytics event:event];
    [self logEvent:event];
}

-(void)demoAnalyticsSwipSuccess{
    NSString *event = @"刷卡成功";
    [AVAnalytics event:event];
    [self logEvent:event];
}

-(void)demoAnalyticsSwipError{
    NSString *event = @"刷卡失败";
    [AVAnalytics event:event];
    [self logEvent:event];
}

-(void)demoAnalyticsRefund{
    NSString *event = @"退货";
    [AVAnalytics event:event];
    [self logEvent:event];
}

-(void)demoAnalyticsReverse{
    NSString *event = @"冲正";
    [AVAnalytics event:event];
    [self logEvent:event];
}

-(void)demoAnalyticsCupsError{
    NSString *event = @"CUPS错误";
    [AVAnalytics event:event];
    [self logEvent:event];
}

MakeSourcePath
@end
