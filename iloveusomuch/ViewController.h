#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIImageView *background;
    IBOutlet UIStackView *contents;
    AVPlayerLayer *loaderPlayer;
    BOOL skipLoadingScreen;
}

- (IBAction)play;
- (IBAction)share: (UIButton*)sender;
- (IBAction)listen;
- (void)didEnterBackground:(NSNotification *)notification;
- (void)willEnterForeground:(NSNotification *)notification;
- (void)loaderDidFinish:(NSNotification *)notification;
- (UIAlertAction*)generateStreamingButton: (NSString*)name url:(NSString*)url;

@property(retain, nonatomic) AVPlayerLayer *loaderPlayer;
@property BOOL skipLoadingScreen;

@end

