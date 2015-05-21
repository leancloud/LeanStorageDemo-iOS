//
//  AVSNSBasic.m
//  AVOSDemo
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "AVSMSBasic.h"

#warning 配置您的手机号码
static NSString *testPhoneNumber = @"132616309x";

@implementation AVSMSBasic

- (void)demoRequestSmsCode {
    // 需要在设置中勾选 "启用帐号无关短信验证服务"
    if ([testPhoneNumber containsString:@"x"]) {
        [self log:@"请先在代码中配置您的手机号码"];
        return;
    }
    [AVOSCloud requestSmsCodeWithPhoneNumber:testPhoneNumber appName:@"玩拍" operation:@"注册" timeToLive:10 callback: ^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"请求短信验证码成功，手机号码为 %@", testPhoneNumber]];
        }
    }];
}

- (void)demoVerifySmsCode {
    // 请先用上一个示例来请求验证短信
    NSString *smsCode = @"339237";
    [AVOSCloud verifySmsCode:smsCode mobilePhoneNumber:testPhoneNumber callback:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"验证成功，手机号码为 %@，验证码为 %@", testPhoneNumber,smsCode]];
        }
    }];
}

MakeSourcePath

@end
