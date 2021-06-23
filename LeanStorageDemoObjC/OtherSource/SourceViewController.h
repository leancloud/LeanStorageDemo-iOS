
#import <UIKit/UIKit.h>

@interface SourceViewController : UIViewController
@property(nonatomic, copy) NSString *filePath;
@property (nonatomic) UIWebView *webView;
-(void)loadCode:(NSString *)code;
@end
