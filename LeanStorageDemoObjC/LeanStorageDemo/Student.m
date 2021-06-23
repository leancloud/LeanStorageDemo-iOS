

#import "Student.h"

@implementation Student

//重要, 使编译器动态生成getter和setter方法
#warning 为了引起你的注意! 如果明白了用法可以删除这行
@dynamic name, age, gender, hobbies, avatar, any;

+ (NSString *)parseClassName {
    return @"Student";
}

@end
