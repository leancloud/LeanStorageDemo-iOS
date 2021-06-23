
#import "EngineBasic.h"
#import "Demo+Utils.h"

/*!
 *  云引擎与 SDK 的交互，需要结合云引擎项目学习 https://github.com/leancloud/sdk-demo-engine/blob/master/cloud.js
 */
@implementation EngineBasic

- (void)demoCallCloudFunction {
    [LCCloud callFunctionInBackground:@"hello" withParameters:nil block:^(id object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"云引擎返回结果：%@", object];
        }
    }];
}

- (void)demoErrorCode_ {
    [LCCloud callFunctionInBackground:@"errorCode" withParameters:nil block:^(id object, NSError *error) {
        if (!object && error && error.code == 211) {
            [self log:@"云引擎返回的 Error ：%@", error];
        }
    }];
}

- (void)demoCustomErrorCode_ {
    NSError *error;
    id response = [LCCloud callFunction:@"customErrorCode" withParameters:nil error:&error];
    if (!response && error && error.code == 123) {
        [self log:@"云引擎返回的 Error ：%@", error];
    }
}

-(void)demoFetchObject {
    [self createStudentForDemo:^(Student *student) {
        Student *fetchStudent = [Student objectWithoutDataWithObjectId:student.objectId];
        
        NSDictionary *params=@{@"obj":fetchStudent};
        [LCCloud callFunctionInBackground:@"fetchObject" withParameters:params block:^(id object, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"云引擎返回的结果：%@", object];
                [fetchStudent objectFromDictionary:object];
                
                [self log:@"根据返回结果构造的对象：%@", fetchStudent];
            }
        }];
    }];
}

-(void)demoFetchFullObject {
    [LCCloud callFunctionInBackground:@"fullObject" withParameters:nil block:^(id object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从云引擎中获取整个对象：%@", object];
        }
    }];
}

- (void)demoBeforeSave {
    LCObject *object = [LCObject objectWithClassName:@"LCCloudTest"];
    object[@"string"] = @"This is too much long, too much long, too long";
    object.fetchWhenSave = YES; // 保存的时候也获取最新属性
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"通过 beforeSave Hook 截断至 10个字符：%@", object[@"string"]];
        }
    }];
}

MakeSourcePath

@end
