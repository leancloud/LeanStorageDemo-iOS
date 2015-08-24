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

#pragma mark - 简单的增删改查

-(void)demoCreateObject{
    Student *student = [[Student alloc] init];
    student.name = @"Mike";
    student.age=12;
    student.gender=GenderMale;
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"创建成功 %@", student];
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

#pragma mark - 复杂一点的数据操作

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

- (void)demoFromDictionaryCreateObject {
    NSString *json = @"{\"result\":[{\"gender\":true,\"profileThumbnail\":{\"__type\":\"File\",\"id\":\"5416e87fe4b0f645f29e15cd\",\"name\":\"ugQgIhsiRCBmAyUXPiJBIXvMEQHmq2zoRV6RVabF\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/4nTUcDbKVGDZymrd\"},\"profilePicture\":{\"__type\":\"File\",\"id\":\"5416e877e4b0f645f29e15b6\",\"name\":\"fdrWE627VCPGB8pi1p343XiYk3f2m93mEtU3IvLD\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/eyeFsPgmhxlaPfK8\"},\"activeness\":0,\"nickName\":\"璇璇\",\"likedCount\":750,\"pickiness\":0.15086206896551724,\"username\":\"18588888888\",\"viewedCount\":962,\"viewCount\":232,\"mobilePhoneVerified\":false,\"nearestOnline\":0,\"peerId\":\"18588888888\",\"importFromParse\":false,\"emailVerified\":false,\"signature\":\"~大家好~!希望在钟情交到一些朋友!喜欢我的话就赞我吧！\",\"likeCount\":35,\"recommendIndex\":0.6376030539823643,\"postCount\":3,\"hotness\":0.7796257796257796,\"meetedUser\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"playlistRel\":{\"__type\":\"Relation\",\"className\":\"Playlist\"},\"lastOnlineDate\":{\"__type\":\"Date\",\"iso\":\"2014-10-01T03:55:28.163Z\"},\"birthday\":{\"__type\":\"Date\",\"iso\":\"1991-03-15T13:22:12.000Z\"},\"post0\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/k4TO50kRytl2YTAR.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"QOoUkunpDf8LwRAegol7M07Pia3p8umgBSJtsXqn\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/Gu6uLsGds6FqKnWJ\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"5412c79be4b080380a4895b6\",\"createdAt\":\"2014-09-12T10:14:51.102Z\",\"updatedAt\":\"2014-09-12T10:14:51.108Z\"},\"post1\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/aNm5STA2uuVAXrJi.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"CtGjAUT1JoKo9JI5CL0xWMsm0NVjjU0CWL9UO4DB\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/GPWno3YM2L6D08ub\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"541934ece4b013b181daab26\",\"createdAt\":\"2014-09-17T07:14:52.461Z\",\"updatedAt\":\"2014-09-17T07:14:52.473Z\"},\"post2\":{\"media\":{\"__type\":\"File\",\"name\":\"media.mp4\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/KwsYBMOzyGXZGzDU.mp4\"},\"cover\":{\"__type\":\"File\",\"name\":\"lUNfftRFnu2xJ7IONu1wAoMtAQFEERTADkLmKST7\",\"url\":\"http://ac-mgqe2oiy.qiniudn.com/YOR7l2ws58DlJYiG\"},\"posterRlt\":{\"__type\":\"Relation\",\"className\":\"_User\"},\"objectId\":\"5419a7d2e4b0002e6997c743\",\"createdAt\":\"2014-09-17T15:25:06.765Z\",\"updatedAt\":\"2014-09-17T15:25:06.782Z\"},\"objectId\":\"5416e880e4b0f645f29e15ce\",\"createdAt\":\"2014-09-15T13:24:16.128Z\",\"updatedAt\":\"2014-10-09T07:50:40.971Z\"}]}";
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    NSDictionary *o = [[dict objectForKey:@"result"] objectAtIndex:0];
    AVUser *user = [AVUser user];
    [user objectFromDictionary:o];
    [self log:@"从一大段文本创建了User对象，user:%@", json, user];
}

- (void)demoWithDictionaryCreateObject {
    NSDictionary *dict = @{@"name":@"Mike"};
    Student *student = [Student objectWithClassName:[Student parseClassName] dictionary:dict];
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"用字典赋值字段并保存成功！student:%@", student];
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

- (void)demoAnyType {
    Student *student = [Student object];
    student.any = @(1);
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"Student 的 any 列被保存为了数字: %@", student];
            student.any =@"hello world";
            [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"Student 的 any 列被保存为了字符串：%@", student];
                    student.any = @{@"score":@(100), @"name":@"kitty"};
                    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if ([self filterError:error]) {
                            [self log:@"Student 的 any 列被保存为了字典：%@", student];
                            [self log:@"结束"];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)demoGetAllKeys {
    [self createStudentForDemo:^(Student *student) {
        [self log:@"对象的所有字段为：%@", [student allKeys]];
    }];
}

- (void)demoRemoveKey {
    [self createStudentForDemo:^(Student *student) {
        [self log:@"移除前有字段：%@", [student allKeys]];
        [student removeObjectForKey:kStudentKeyName];
        [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"移除后有字段：%@", [student allKeys]];
            }
        }];
    }];
}

- (void)demoSubscriptingReadWrite {
    Student *student = [Student object];
    // 下标赋值
    student[kStudentKeyName] = @"subscript";
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"下标访问学生名字 :%@", student[kStudentKeyName]];
        }
    }];
}

#pragma mark - 数组操作

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

- (void)demoArrayAddMultipleObject {
    [self createStudentForDemo:^(Student *student) {
        [self log:@"添加前，student.hobbies = %@", student.hobbies];
        [student addObjectsFromArray:@[@"table tennis", @"fly"] forKey:kStudentKeyHobbies];
        [self log:@"将两个爱好添加到了爱好数组里"];
        [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"添加后，student.hobbies = %@", student.hobbies];
            }
        }];
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
            // 或者用：[student removeObjectsInArray:@[@"swimming"] forKey:kStudentKeyHobbies];
            [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"hobbis after: %@", student.hobbies];
                }
            }];
        }
    }];
}

- (void)demoArrayAddUniqueObject {
    [self createStudentForDemo:^(Student *student) {
        [self log:@"hobbis before : %@", student.hobbies];
        [student addUniqueObject:@"swimming" forKey:kStudentKeyHobbies];
        // 或者用下面语句
        // [student addUniqueObjectsFromArray:@[@"swimming"] forKey:kStudentKeyHobbies];
        [self log:@"添加了唯一对象 swimming 到爱好数组中"];
        [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [self log:@"hobbis after: %@", student.hobbies];
            }
        }];
    }];
}

#pragma mark - 批量操作

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

- (void)demoBatchCreateObjectAndFile {
    NSMutableArray *students = [NSMutableArray array];
    for (int i = 10; i < 15; i++) {
        Student *student = [Student object];
        AVFile *avatar=[AVFile fileWithName:@"avatar.jpg" contentsAtPath:[[NSBundle mainBundle] pathForResource:@"alpacino.jpg" ofType:nil]];
        student.avatar = avatar;
        student.age = i;
        [students addObject:student];
    }
    [AVObject saveAllInBackground:students block:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"批量了保存了10个学生及其头像，他们是：%@", students];
        }
    }];
}

MakeSourcePath

@end
