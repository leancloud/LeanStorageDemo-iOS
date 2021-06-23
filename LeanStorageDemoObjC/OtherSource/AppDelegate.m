//
//  AppDelegate.m
//  LCOSDemo
//
//  Created by Travis on 13-11-5.
//  Copyright (c) 2013年 LCOS. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoListC.h"


#import "Student.h"
#import "Post.h"

#warning 请替换成自己的id和key，来查看自己的后台数据
#define LeanCloudAppID  @"G3ROSsF7zRSA3vHD5zw7mDv1"
#define LeanCloudAppKey @"xx0gLOhJsksq4DauasmJrTGf"
#define LeanCloudServerUrl @"https://g3rossf7.lc-cn-n1-shared.com"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* 重要! 注册子类 App生命周期内 只需要执行一次即可*/
    [Student registerSubclass];
    [Post registerSubclass];
    
    //设置LCOSCloud
    [LCApplication setApplicationId:LeanCloudAppID clientKey:LeanCloudAppKey serverURLString:LeanCloudServerUrl];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self rootController];
    [self.window makeKeyAndVisible];
    
    // 输出内部日志，发布时记得关闭
#ifdef DEBUG
    [LCApplication setAllLogsEnabled:YES];
#endif
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[LCInstallation defaultInstallation] setDeviceTokenFromData:deviceToken
                                                          teamId:@"7J5XFNL99Q"];
    [[LCInstallation defaultInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // save succeeded
        } else if (error) {
            NSLog(@"%@", error);
        }
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
}

#pragma mark - DemoApp的方法, 不需要关注

- (UIViewController *)rootController {
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DemoConfig" ofType:@"plist"]];
    
    NSMutableArray *tabs = [NSMutableArray array];
    
    NSArray *keys = [config allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*)obj1 compare:obj2];
    }];
    
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        id object = config[key];
        if ([object isKindOfClass:[NSArray class]]) {
            DemoListC *listC = [[DemoListC alloc] init];
            listC.title = NSLocalizedString(key, nil);
            listC.tabBarItem.image = [UIImage imageNamed:@"cloud"];
            
            listC.contents=object;
            [tabs addObject:listC];
        }else if ([object isKindOfClass:[NSString class]]) {
            Class cl= NSClassFromString(object);
            if (cl) {
                UIViewController * controller = [[cl alloc] init];
                controller.title = NSLocalizedString(key, nil);
                [tabs addObject:controller];
            }
        }
    }
    
    UITabBarController *tabC = [[UITabBarController alloc] init];
    tabC.delegate = self;
    [tabC setViewControllers:tabs];
    tabC.selectedIndex = 0;
    tabC.title = [tabs[tabC.selectedIndex] title];
    
    if ([tabC respondsToSelector:@selector(edgesForExtendedLayout)])
        tabC.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tabC];

    return nc;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    tabBarController.title = viewController.title;
}

@end
