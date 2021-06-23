

#import "OtherBasic.h"

@implementation OtherBasic

- (void)demoGetServerDate {
    [LCApplication getServerDateWithBlock:^(NSDate *date, NSError *error) {
        [self log:@"服务器时间为：%@", date];
    }];
}

- (void)demoConfigNetworkTimeout {
    NSTimeInterval timerInterval = [LCApplication networkTimeoutInterval];
    [LCApplication setNetworkTimeoutInterval:0.01];
    [LCApplication getServerDateWithBlock:^(NSDate *date, NSError *error) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            [self log:@"因为设置了 0.01 秒超时，所以该请求超时了。"];
        } else {
            [self log:@"%@", error];
        }
        [LCApplication setNetworkTimeoutInterval:timerInterval];
    }];
}

MakeSourcePath

@end
