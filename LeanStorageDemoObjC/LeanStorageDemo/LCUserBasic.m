

#import "LCUserBasic.h"

static NSString * const kDemoUsername = @"XiaoMing";
static NSString * const kDemoPassword = @"123456";

@implementation LCUserBasic

- (void)logUnLogin {
    [self log:@"未有用户登录，请先运行用户登录的示例"];
}

- (void)demoCurrentUser {
    LCUser *user = [LCUser currentUser];
    if (user) {
        [self log:@"当前用户 %@ , 用户名 %@", user, user.username];
        [self log:@"此时可直接跳转主页面"];
    } else {
        [self logUnLogin];
    }
}

- (void)demoLogoutUser {
    LCUser *user = [LCUser currentUser];
    if (user) {
        [self log:@"注销用户 %@", user.username];
        [LCUser logOut];
    } else {
        [self logUnLogin];
    }
}

- (void)demoDeleteCurrentUser {
    LCUser *user = [LCUser currentUser];
    if (user) {
        [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self log:@"%@", error];
            }
            [LCUser logOut];
            [self log:@"已删除用户 %@", user.username];
        }];
    } else {
        [self logUnLogin];
    }
}

- (void)demoUsernameRegister {
    LCUser *user = [LCUser user];
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
    [LCUser logInWithUsernameInBackground:kDemoUsername password:kDemoPassword block:^(LCUser *user, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"登录成功 %@", user];
        }
    }];
}

- (void)demoOldPasswordUpdatePassword {
    LCUser *user = [LCUser currentUser];
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
            LCUser *user = [LCUser user];
            user.username = email;
            user.password = kDemoPassword;
            user.email = email;
            user[@"gender"] = @"男" ;
            // 需要在网站勾选启用注册用户邮箱验证，否则不会发验证邮件
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"用户注册成功 %@", user];
                    LCUser *user = [LCUser currentUser];
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
            [LCUser logInWithUsernameInBackground:email password:kDemoPassword block:^(LCUser *user, NSError *error) {
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
            [LCUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"重置密码的连接已经发送到用户邮箱 %@", email];
                }
            }];
        }
    }];
}

#pragma mark - phone number

- (void)demoPhoneNumberAndPasswordLogin {
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号码来登录" block:^(BOOL confirm, NSString *text) {
        if (confirm) {
            [LCUser logInWithMobilePhoneNumberInBackground:text password:kDemoPassword block:^(LCUser *user, NSError *error) {
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
            [LCUser requestLoginSmsCode:phoneNumber withBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"验证码已发送，请输入验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            [LCUser logInWithMobilePhoneNumberInBackground:phoneNumber smsCode:smsCode block:^(LCUser *user, NSError *error) {
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
            [LCUser requestPasswordResetWithPhoneNumber:phoneNumber block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"短信已发送，请输入验证码来重置密码" block:^(BOOL confirm, NSString *smsCode) {
                        if (confirm) {
                            NSString *newPassword = @"111111";
                            [LCUser resetPasswordWithSmsCode:smsCode newPassword:newPassword block:^(BOOL succeeded, NSError *error) {
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
    [self.alertViewHelper showInputAlertViewWithMessage:@"请输入手机号码" block:^(BOOL confirm, NSString *phoneNumber) {
   if (confirm) {
            LCUser *user = [LCUser user];
            user.username = kDemoUsername;
            user.password =  kDemoPassword;
            user.mobilePhoneNumber = phoneNumber;
            [LCSMS requestShortMessageForPhoneNumber:phoneNumber options:nil callback:^(BOOL succeeded, NSError * _Nullable error) {
                if ([self filterError:error]) {
                    [self.alertViewHelper showInputAlertViewWithMessage:@"验证短信已发送，请输入验证码" block:^(BOOL confirm, NSString *smsCode) {
                        if (smsCode) {
                            [LCUser signUpOrLoginWithMobilePhoneNumberInBackground:@"+8618200008888" smsCode:@"123456" block:^(LCUser *user, NSError *error) {
                                if ([self filterError:error]) {
                                    [self log:@"注册或登录成功 user:%@", user];
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
    [LCUser loginAnonymouslyWithCallback:^(LCUser *user, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"匿名用户登录成功，user : %@ \n username : %@ ", user, user.username];
        }
    }];
}
@end


