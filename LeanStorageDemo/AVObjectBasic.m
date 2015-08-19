//
//  AVObjectBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "Student.h"
#import "AVObjectBasic.h"
#import <AVOSCloud/AVOSCloud.h>

static NSString *kDemoStudentId = @"55750444e4b0f22726a0c9bb";

@implementation AVObjectBasic

-(void)demoCreateObject{
    Student *student = [[Student alloc] init];
    student.name = @"Mike";
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"创建成功 %@", student];
        }
    }];
}

- (void)demoCreateObjectAndFile {
    Student *student = [Student object];
    student.name = @"Mike";
    AVFile *avatar=[AVFile fileWithName:@"avatar.jpg" contentsAtPath:[[NSBundle mainBundle] pathForResource:@"alpacino.jpg" ofType:nil]];
    
    student.avatar = avatar;
    
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"保存对象与文件成功。 student : %@", student];
        }
    }];
}

- (void)demoWithDictionaryCreateObject {
    NSDictionary *dict = @{@"name":@"Mike"};
    Student *student = [Student object];
    [student objectFromDictionary:dict];
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"用字典赋值字段并保存成功！student:%@", student];
        }
    }];
}

-(void)demoUpdateObject{
    //我们先创建一个Object 才可以更新
    Student *student = [[Student alloc] init];
    student.name = @"Mike";
    
    //Object也可以用同步方法保存
    [student save];
    
    [self log:@"创建一个Student, 名字是:%@",student.name];
    
    //更新操作
    student.name = @"Jack";
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"更新成功: 名字变成了%@", student.name];
        }
    }];
    
}

-(void)demoDeleteObject{
    Student *student = [[Student alloc] init];
    student.name = @"Mike";
    [student save];
    
    //开始删除操作
    [student deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"删除成功"];
        }
    }];
}

-(void)demoGetObject{
    AVObject *student=[AVObject objectWithoutDataWithClassName:@"Student" objectId:@"55750444e4b0f22726a0c9bb"];
    [student fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"获取成功: %@", object];
        }
    }];
}

- (void)demoOfflineCreateObject{
    // 不管在线还是离线都能保存，这里测试离线是否能保存
    [self log:@"请在网络关闭时运行本方法，然后开启网络，看是否保存上"];
    AVObject *object=[AVObject objectWithClassName:@"Student"];
    [object setObject:NSStringFromSelector(_cmd) forKey:@"name"];
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        [self log:@"error : %@", error];
        [self log:@"离线保存完毕，请开启网络"];
    }];
}

- (void)demoCounter {
    Student *student = [Student objectWithoutDataWithObjectId:kDemoStudentId];
    // 保存的时候同时获取最新值
    student.fetchWhenSave = YES;
    [student incrementKey:@"age" byAmount:@1];
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"%@ 过生日了 当前年龄为:%@", student[@"objectId"], student[@"age"]];
        }
    }];
}

- (void)demoArrayAddObject {
    Student *student = [Student objectWithoutDataWithObjectId:kDemoStudentId];
    // 获取 Demo 的对象
    [student fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"hobbis before : %@", student.hobbies];
            // 添加对象到数组
            [student addObject:@"swimming" forKey:kStudentKeyHobbies];
            [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"hobbis after: %@", student.hobbies];
                }
            }];
        }
    }];
}

- (void)demoArrayRemoveObject {
    Student *student = [Student objectWithoutDataWithObjectId:kDemoStudentId];
    // 获取 Demo 的对象
    [student fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"hobbis before : %@", student.hobbies];
            // 移除对象到数组
            [student removeObject:@"swimming" forKey:kStudentKeyHobbies];
            [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"hobbis after: %@", student.hobbies];
                }
            }];
        }
    }];
}

- (void)createStudentsForDemo:(AVArrayResultBlock)block {
    NSMutableArray *students = [NSMutableArray array];
    for (int i = 10; i < 20; i++) {
        Student *student = [Student object];
        student.age = i;
        [students addObject:student];
    }
    [AVObject saveAllInBackground:students block:^(BOOL succeeded, NSError *error) {
        if (error) {
            block(nil, error);
        } else {
            block(students, nil);
        }
    }];
}

- (void)demoBatchCreate {
    NSMutableArray *students = [NSMutableArray array];
    for (int i = 10; i < 20; i++) {
        Student *student = [Student object];
        student.age = i;
        [students addObject:student];
    }
    [AVObject saveAllInBackground:students block:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"批量创建了10个学生！他们是：%@", students];
        }
    }];
}

- (void)demoBatchFetch {
    // 先保存10个学生，示例用
    [self createStudentsForDemo:^(NSArray *students, NSError *error) {
        if ([self filterError:error]) {
            NSMutableArray *fetchStudents = [NSMutableArray array];
            for (Student *student in students) {
                // 构造对象，无数据
                Student *fetchStudent = [Student objectWithoutDataWithObjectId:student.objectId];
                [fetchStudents addObject:fetchStudent];
            }
            [AVObject fetchAllIfNeededInBackground:fetchStudents block:^(NSArray *objects, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"批量获取了10个学生！他们是：%@",fetchStudents];
                }
            }];
        }
    }];
}

- (void)demoBatchUpdate {
    // 先保存10个学生，示例用
    [self createStudentsForDemo:^(NSArray *students, NSError *error) {
        if ([self filterError:error]) {
            for (Student *student in students) {
                // 构造对象，无数据
                student.name = @"Mike";
            }
            [AVObject saveAllInBackground:students block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"批量更新了10个学生！他们是：%@",students];
                }
            }];
        }
    }];
}

- (void)demoBatchDelete {
    [self createStudentsForDemo:^(NSArray *students, NSError *error) {
        if ([self filterError:error]) {
            [AVObject deleteAllInBackground:students block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"批量删除了10个学生！他们是：%@",students];
                }
            }];
        }
    }];
}

MakeSourcePath
@end
