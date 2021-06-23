
#import <UIKit/UIKit.h>
#import "Student.h"

#define kPostKeyLikes @"likes"
#define kPostKeyAuthor @"author"
#define kPostKeyContent @"content";

@interface Post : LCObject<LCSubclassing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) Student *author;
@property (nonatomic, strong) NSArray *likes; //Student Array

@end
