#import "LCQueryBasic.h"
#import "Student.h"
#import "Post.h"
#import "Demo+Utils.h"

@implementation LCQueryBasic

- (void)demoByClassNameQuery {
    LCQuery *query = [Student query];
    //限制查询返回数
    [query setLimit:3];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果: \n%@", objects];
        }
    }];
}

- (void)demoByGeoQuery {
    LCQuery *query = [Student query];
    //我们要找这个点附近的Student
    LCGeoPoint *geo = [LCGeoPoint geoPointWithLatitude:31.9 longitude:114.78];
    [query whereKey:@"location" nearGeoPoint:geo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%@", [objects description]]];
        }
    }];
}

- (void)demoOnlyGetQueryResultCount {
    LCQuery *query = [Student query];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if ([self  filterError:error]) {
            [self log:[NSString stringWithFormat:@"查询结果: \n%ld个Student", (long)number]];
        }
    }];
}

- (void)demoAndQuery_ {
    LCQuery *query1 = [Student query];
    [query1 whereKey:kStudentKeyName notEqualTo:@"Mike"];;
    
    LCQuery *query2 = [Student query];
    [query2 whereKey:kStudentKeyName hasPrefix:@"M"];
    
    LCQuery *query = [LCQuery andQueryWithSubqueries:@[query1, query2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"名字不为 Mike 且 M 开头的学生：%@", objects];
        }
    }];
}

- (void)demoOrQuery_ {
    LCQuery *query1 = [Student query];
    [query1 whereKey:kStudentKeyName equalTo:@"Mike"];
    
    LCQuery *query2 = [Student query];
    [query2 whereKey:kStudentKeyName hasPrefix:@"J"];
    
    LCQuery *query = [LCQuery orQueryWithSubqueries:@[query1, query2]];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"名字为 Mike 或 J 开头的学生有 %ld 个", number];
        }
    }];
}

- (void)demoByKeyOrder {
    LCQuery *query = [Student query];
    [query orderByDescending:kStudnetKeyAge];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"年龄从大到小排序的学生：%@", objects];
        }
    }];
}

- (void)demoAddSecondOrder {
    LCQuery *query = [Student query];
    [query orderByDescending:kStudnetKeyAge];
    [query addDescendingOrder:kStudentKeyName];
    [query setLimit:5];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"先按年龄从大到小排，再按名字排序，结果为：%@", objects];
        }
    }];
}

- (void)demoBySortDescriptorsOrder {
    LCQuery *query = [Student query];
    [query orderBySortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:kStudnetKeyAge ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:kStudentKeyName ascending:YES]]];
    [query setLimit:5];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"先按年龄从大到小排，再按名字排序，结果为：%@", objects];
        }
    }];
}

- (void)demoByArraySizeQuery {
    LCQuery *query = [Student query];
    // 数组大小
    [query whereKey:kStudentKeyHobbies sizeEqualTo:1];
    [query setLimit:4];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"爱好有一个的学生：%@", objects];
        }
    }];
}

- (void)demoContainedIn {
    LCQuery *query = [Student query];
    [query whereKey:kStudentKeyName containedIn:@[ @"Mike", @"Jane" ]];
    query.limit = 5;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"名字为 Mike 或 Jane 的学生：%@", objects];
        }
    }];
}

- (void)demoContainObjectsInArray_ {
    LCQuery *query = [Student query];
    [query whereKey:kStudentKeyHobbies containsAllObjectsInArray:@[ @"swimming", @"running" ]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"爱好有 swimming 和 running 的学生", objects];
        }
    }];
}

- (void)demoLimitResultCount {
    LCQuery *query = [Student query];
    // 默认 100，最大 1000
    query.limit = 5;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"仅查找五个学生：%@", objects];
        }
    }];
}

- (void)demoRegex {
    LCQuery *query = [Student query];
    NSString *regex = @"^M.*";
    [query whereKey:kStudentKeyName matchesRegex:regex];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"名字满足正则表达式 %@ 的学生：%@", regex, objects];
        }
    }];
}

- (void)demoOneKeyMultipleCondition {
    LCQuery *query = [Student query];
    [query whereKey:kStudentKeyName hasPrefix:@"M"];
    [query whereKey:kStudentKeyName hasSuffix:@"e"];
    [query whereKey:kStudentKeyName containsString:@"i"];
    [query setLimit:3];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"名字有前缀 M 和后缀 e且包含字符 i 的学生：%@", objects];
        }
    }];
}

- (void)demoQueryEqualToObject_ {
    LCQuery *query1 = [Student query];
    // 获取一个学生作为示例
    [query1 getFirstObjectInBackgroundWithBlock:^(LCObject *student, NSError *error) {
        if ([self filterError:error]) {
            LCQuery *query = [Post query];
            // 直接等于某个对象
            [query whereKey:kPostKeyAuthor equalTo:student];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if ([self filterError:error]) {
                    // 如果为空，可以到 PointerBasic 运行示例，demoRelateObject，产生一条微博
                    [self log:@"找到第一个学生发的微博：%@", objects];
                }
            }];
        }
    }];
}

- (void)demoMatchesInSubquery {
    LCQuery *query = [Student query];
    [query orderByDescending:@"createdAt"];
    query.limit = 50;
    
    LCQuery *postQuery = [Post query];
    [postQuery whereKey:kPostKeyAuthor matchesQuery:query];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"最近创建的50个学生的微博：%@", objects];
        }
    }];
}

- (void)demoDoesNotMatchesInSubquery_ {
    LCQuery *query = [Student query];
    [query orderByDescending:@"createdAt"];
    query.limit = 50;
    
    LCQuery *postQuery = [Post query];
    [postQuery whereKey:kPostKeyAuthor doesNotMatchQuery:query];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"除去最近50个学生创建的微博：%@", objects];
        }
    }];
}

- (void)demoLastModifyEnabled {
    // 放在 AppDelegate 较好
    [LCApplication setLastModifyEnabled:YES];
    
    [self createStudentForDemo:^(Student *student) {
        LCQuery *query = [Student query];
        // 此次应该走了网络
        [query getObjectInBackgroundWithId:student.objectId block:^(LCObject *object, NSError *error) {
            if ([self filterError:error]) {
                // 客户端把该对象的 udpatedAt 传给服务器，服务器判断对象未改变，于是返回 304 和空数据，客户端返回本地缓存的数据，节省流量
                [query getObjectInBackgroundWithId:student.objectId block:^(LCObject *object, NSError *error) {
                    if ([self filterError:error]) {
                        [self log:@"从缓存中获得数据：%@", object];
                    }
                }];
            }
        }];
    }];
}

- (void)demoLastModifyEnabled2 {
    // 放在 AppDelegate 较好，建议开启，节省流量
    [LCApplication setLastModifyEnabled:YES];
    
    LCQuery *query = [Student query];
    query.limit = 5;
    // 从网络获取了数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            // 服务器记录表的修改时间，如果两次查询之间表未被修改且参数一样，则以下查询将从本地缓存获取数据
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if ([self filterError:error]) {
                    [self log:@"从本地缓存中获得数据：%@", objects];
                }
            }];
        }
    }];
}

- (void)demoQueryPolicyCacheThenNetwork_ {
    LCQuery *query = [Student query];
    query.cachePolicy = kLCCachePolicyCacheThenNetwork;
    query.maxCacheAge = 60 * 60; // 单位秒
    query.limit = 1;
    __block NSInteger count = 0;
    if ([query hasCachedResult]) {
        [self log:@"查询前有缓存"];
    } else {
        [self log:@"查询前无缓存"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (count == 0) {
            [self log:@"第一次从缓存中获取结果：%@", objects];
        } else {
            [self log:@"第二次从网络获取结果：%@", objects];
            [query clearCachedResult];
            [self log:@"为了演示，清除了查询缓存"];
        }
        count ++;
    }];
}

- (void)demoQueryPolicyCacheElseNetwork_ {
    LCQuery *query = [Student query];
    query.cachePolicy = kLCCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 60; // 单位秒
    query.limit = 6;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，将从缓存中获取结果"];
    } else {
        [self log:@"无缓存，将从网络获取结果"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyNetworkElseCache_ {
    LCQuery *query = [Student query];
    query.cachePolicy = kLCCachePolicyNetworkElseCache;
    query.maxCacheAge = 60 * 60; // 单位秒
    query.limit = 4;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，无网络时将从缓存获取结果"];
    } else {
        [self log:@"无缓存，有网络则从网络获取结果，否则将失败"];
    }
    // 运行过一次后可以关闭网络来看看是否从缓存中获取结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"查询结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyNetworkOnly_ {
    LCQuery *query = [Student query];
    // 跟默认 IngoreCache 策略不同的是此策略会记录缓存
    query.cachePolicy = kLCCachePolicyNetworkOnly;
    query.maxCacheAge = 60 * 60; // 单位秒
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从网络获取了结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyCacheOnly_ {
    LCQuery *query = [Student query];
    query.cachePolicy = kLCCachePolicyCacheOnly;
    query.maxCacheAge = 60 * 60; // 单位秒
    query.limit = 2;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，将从缓存中获取"];
    } else {
        [self log:@"无缓存，将失败"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"从缓存中获取了结果：%@", objects];
        }
    }];
}

- (void)demoQueryPolicyIgnoreCache_ {
    LCQuery *query = [Student query];
    // 默认策略，不用设置也行，查询结果将不记录到本地
    query.cachePolicy = kLCCachePolicyIgnoreCache;
    query.limit = 2;
    if ([query hasCachedResult]) {
        [self log:@"有缓存，但无视之"];
    } else {
        [self log:@"无缓存，也无视之"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"获取了结果：%@", objects];
        }
    }];
}

- (void)demoClearAllCache {
    [LCQuery clearAllCachedResults];
    [self log:@"已清除所有的缓存结果"];
}

MakeSourcePath

@end
