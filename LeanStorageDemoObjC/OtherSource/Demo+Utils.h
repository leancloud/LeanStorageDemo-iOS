
#import "Demo.h"

#import "Student.h"

typedef void (^StudentBlock) (Student *student);

@interface Demo (Utils)

- (void)createStudentForDemo:(StudentBlock)block;

@end
