//
//  AlertViewHelper.h
//  AVOSDemo
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InputAlertViewFinishBlock)(NSString *text);

@interface AlertViewHelper : NSObject

- (void)showInputAlertViewWithMessage:(NSString*)message block:(InputAlertViewFinishBlock)block ;

@end
