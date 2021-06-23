

#import "LCSMSBasic.h"

@implementation LCSMSBasic

- (void)demoRequestSmsCode {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入您的手机号码进行注册" block:^(BOOL confirm, NSString *phoneNumber) {
        if (confirm) {
            LCShortMessageRequestOptions *options = [[LCShortMessageRequestOptions alloc] init];
            options.TTL = 10;                     // 验证码有效时间为 10 分钟
            options.applicationName = @"应用名称"; // 应用名称
            options.operation = @"某种操作";       // 操作名称
            [LCSMS requestShortMessageForPhoneNumber:phoneNumber
                                           options:options
                                           callback:^(BOOL succeeded, NSError * _Nullable error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"短信验证码请求成功，请输入您收到的验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                         
                            [LCApplication verifySmsCode:smsCode mobilePhoneNumber:phoneNumber callback:^(BOOL succeeded, NSError *error) {
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
@end

