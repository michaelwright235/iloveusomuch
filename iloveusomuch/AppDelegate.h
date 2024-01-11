#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    ViewController *viewController;
}
@property(retain, nonatomic) ViewController *viewController;
@property(retain, nonatomic) UIWindow *window;

@end

