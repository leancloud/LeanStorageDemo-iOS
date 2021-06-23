
#import <UIKit/UIKit.h>
#import "Demo.h"

@interface DemoRunC : UIViewController

@property(nonatomic, assign) Demo *demo;

@property(nonatomic, copy) NSString *methodName;

@property(nonatomic, retain) NSString *sourceCode;
@property(nonatomic,weak)UIView *sourceCodeView;

-(void)onFinish;
@end
