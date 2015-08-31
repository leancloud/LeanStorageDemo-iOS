//
//  Demo+Utils.h
//  LeanStorageDemo
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import "Demo.h"

#import "Student.h"

typedef void (^StudentBlock) (Student *student);

@interface Demo (Utils)

- (void)createStudentForDemo:(StudentBlock)block;

@end
