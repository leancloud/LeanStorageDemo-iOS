
#import "Post.h"

@implementation Post

@dynamic content;
@dynamic author;
@dynamic likes;

+ (NSString *)parseClassName {
    return @"Post";
}

@end
