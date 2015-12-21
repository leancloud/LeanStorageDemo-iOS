//
//  AVUserBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-17.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVUserBasic.h"

static NSString * const kDemoUsername = @"XiaoMing";
static NSString * const kDemoPassword = @"123456";

@implementation AVUserBasic

- (void)logUnLogin {
    [self log:@"未有用户登录，请先运行用户登录的示例"];
}

- (void)demoCurrentUser {
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self log:@"当前用户 %@ , 用户名 %@", user, user.username];
        [self log:@"此时可直接跳转主页面"];
    } else {
        [self logUnLogin];
    }
}

- (void)demoLogoutUser {
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self log:@"注销用户 %@", user.username];
        [AVUser logOut];
    } else {
        [self logUnLogin];
    }
}

- (void)demoDeleteCurrentUser {
    AVUser *user = [AVUser currentUser];
    if (user) {
        [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self log:@"%@", error];
            }
            [AVUser logOut];
            [self log:@"已删除用户 %@", user.username];
        }];
    } else {
        [self logUnLogin];
    }
}

- (void)demoUsernameRegister {
    AVUser *user = [AVUser user];
    user.username = kDemoUsername;
    user.password = kDemoPassword;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"用户注册成功 %@", user];
            [self log:@"当前用户 %@", user.username];
        }
    }];
}

- (void)demoUsernameLogin {
    [AVUser logInWithUsernameInBackground:kDemoUsername password:kDemoPassword block:^(AVUser *user, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"登录成功 %@", user];
        }
    }];
}

- (void)demoOldPasswordUpdatePassword {
    AVUser *user = [AVUser currentUser];
    if (user) {
        NSString *newPassword = @"111111";
        [user updatePassword:kDemoPassword newPassword:newPassword block:^(id object, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"重置密码成功，新的密码为 %@", newPassword];
            }
        }];
    } else {
        [self logUnLogin];
    }
}

#pragma mark - email

- (void)demoEmailRegister {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入您的邮箱来注册" block:^(BOOL confirm, NSString *email) {
        if (confirm) {
            AVUser *user = [AVUser user];
            user.username = email;
            user.password = kDemoPassword;
            user.email = email;
            user[@"gender"] = @"男" ;
            // 需要在网站勾选启用注册用户邮箱验证，否则不会发验证邮件
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"用户注册成功 %@", user];
                    AVUser *user = [AVUser currentUser];
                    [self log:@"当前用户 %@  邮箱 %@  性别 %@", user.username, user.email, user[@"gender"]];
                    [self log:@"请检查邮箱进行验证。"];
                }
            }];
        }
    }];
}

- (void)demoEmailLogin {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入您的邮箱来登录" block:^(BOOL confirm, NSString *email) {
        if (confirm) {
            [AVUser logInWithUsernameInBackground:email password:kDemoPassword block:^(AVUser *user, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"登录成功 %@ ", user];
                }
            }];
        }
    }];
}

- (void)demoEmailResetPassword {
    //假设用户的邮箱是这个 重置密码链接会发到这里 用户打开会重新填写新密码
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入您的邮箱进行重置密码" block:^(BOOL confirm, NSString *email) {
        if (confirm) {
            [AVUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"重置密码的连接已经发送到用户邮箱 %@", email];
                }
            }];
        }
    }];
}

#pragma mark - phone number

// 请在网站勾选 "验证注册用户手机号码" 选项，否则不会发送验证短信
- (void)demoPhoneNumberRegisterUser {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号码" block:^(BOOL confirm, NSString *phoneNumber) {
        if (confirm) {
            AVUser *user = [AVUser user];
            user.username = kDemoUsername;
            user.password =  kDemoPassword;
            user.mobilePhoneNumber = phoneNumber;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"验证短信已发送，请输入验证码" block:^(BOOL confirm, NSString *smsCode) {
                        [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
                            if ([self filterError:error]) {
                                [self log:@"成功注册  手机号 %@ 密码 %@ ", phoneNumber, kDemoPassword];
                            }
                        }];
                    }];
                }
            }];
        }
    }];
}

- (void)demoPhoneNumberAndPasswordLogin {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号码来登录" block:^(BOOL confirm, NSString *text) {
        if (confirm) {
            [AVUser logInWithMobilePhoneNumberInBackground:text password:kDemoPassword block:^(AVUser *user, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"成功登录 用户为 %@", user];
                }
            }];
        }
    }];
}

- (void)demoPhoneNumberAndCodeLogin {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号码来登录" block:^(BOOL confirm, NSString *phoneNumber) {
        if (confirm) {
            [AVUser requestLoginSmsCode:phoneNumber withBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"验证码已发送，请输入验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            [AVUser logInWithMobilePhoneNumberInBackground:phoneNumber smsCode:smsCode block:^(AVUser *user, NSError *error) {
                                if ([self filterError:error]) {
                                    [self log:@"成功登录 用户为%@", user];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)demoPhoneNumberResetPassword {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入需要重置密码的手机号" block:^(BOOL confirm, NSString *phoneNumber) {
        if (confirm) {
            [AVUser requestPasswordResetWithPhoneNumber:phoneNumber block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"短信已发送，请输入验证码来重置密码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            NSString *newPassword = @"111111";
                            [AVUser resetPasswordWithSmsCode:smsCode newPassword:newPassword block:^(BOOL succeeded, NSError *error) {
                                if ([self filterError:error]) {
                                    [self log:@"密码重置成功，新密码为 %@ ", newPassword];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)demoPhoneNumberRegisterOrLogin {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号来注册或登录" block:^(BOOL confirm, NSString *phone) {
        if (confirm) {
            [AVOSCloud requestSmsCodeWithPhoneNumber:phone callback:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error])  {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"验证码已发送，请输入验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:phone smsCode:smsCode block:^(AVUser *user, NSError *error) {
                                if ([self filterError:error]) {
                                    [self log:@"注册或登录成功 phone:%@\nuser:%@", phone, user];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark - anonymous

- (void)demoAnonymousUserLogin {
    [AVAnonymousUtils logInWithBlock:^(AVUser *user, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"匿名用户登录成功，user : %@ \n username : %@ ", user, user.username];
        }
    }];
}

MakeSourcePath

@end
