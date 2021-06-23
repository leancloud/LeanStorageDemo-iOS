
#import "Demo+Utils.h"

@implementation Demo (Utils)

#pragma mark - Demo Utils
- (void)createStudentForDemo:(StudentBlock)block {
    Student *student = [[Student alloc] init];
    student.name = @"Jane";
    student.age = 18;
    student.gender = GenderFamale;
    student.hobbies = @[ @"swimming", @"running" ];
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            block(student);
        }
    }];
}

@end
