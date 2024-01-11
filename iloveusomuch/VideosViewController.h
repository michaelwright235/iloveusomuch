#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface VideoView: UIView
{
    AVPlayerLayer *videosPlayer;
    BOOL swiping;
    float posXStart;
    float swipeXStart;
    float posYStart;
    float swipeYStart;
    BOOL zoomed;
}

@property(retain, nonatomic) AVPlayerLayer *videosPlayer;
@end

@interface VideosViewController: UIViewController
{
    AVPlayerLayer *videosPlayer;
    IBOutlet VideoView *videoView;
}

- (void)videosDidFinish:(NSNotification *)notification;
- (void)didEnterBackground:(NSNotification *)notification;
- (void)willEnterForeground:(NSNotification *)notification;

@property(retain, nonatomic) VideoView *videoView;
@property(retain, nonatomic) AVPlayerLayer *videosPlayer;
@end
