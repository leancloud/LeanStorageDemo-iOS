//
//  AlertViewHelper.m
//  AVOSDemo
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "AlertViewHelper.h"

@interface AlertViewHelper()<UIAlertViewDelegate>

@property (nonatomic, copy) InputAlertViewFinishBlock finishBlock;

@property (nonatomic, strong) NSString *inputText;

@end

@implementation AlertViewHelper

- (void)showInputAlertViewWithMessage:(NSString*)message block:(InputAlertViewFinishBlock)block {
    self.finishBlock = block;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.inputText = [alertView textFieldAtIndex:0].text;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.finishBlock) {
        self.finishBlock(self.inputText);
    }
    self.inputText = nil;
    self.finishBlock = nil;
}

@end
