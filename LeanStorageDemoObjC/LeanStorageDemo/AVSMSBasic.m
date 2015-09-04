//
//  AVSNSBasic.m
//  AVOSDemo
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "AVSMSBasic.h"

@implementation AVSMSBasic

- (void)demoRequestSmsCode {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入您的手机号码进行注册" block:^(BOOL confirm, NSString *phoneNumber) {
        if (confirm) {
            // 需要在网站设置中勾选 "启用帐号无关短信验证服务"
            // 有可能超过 100条免费测试短信，发送失败
            // 短信里的 【】 需要到网站修改应用名，跟下面的appName参数无关
            [AVOSCloud requestSmsCodeWithPhoneNumber:phoneNumber appName:@"玩拍" operation:@"注册" timeToLive:10 callback: ^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"短信验证码请求成功，请输入您收到的验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            [AVOSCloud verifySmsCode:smsCode mobilePhoneNumber:phoneNumber callback:^(BOOL succeeded, NSError *error) {
                                if ([self filterError:error]) {
                                    [self log:[NSString stringWithFormat:@"验证成功，手机号码为 %@，验证码为 %@", phoneNumber, smsCode]];
                                }
                            }];
                        } else {
                            [self log:@"input nothing"];
                        }
                    }];
                }
            }];
        } else {
            [self log:@"input nothing"];
        }
    }];
}

MakeSourcePath

@end
