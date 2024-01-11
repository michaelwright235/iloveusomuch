#import "AppDelegate.h"

@implementation AppDelegate

@synthesize viewController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window addSubview: [self.viewController view]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
