#import "ViewController.h"
#import <AVKit/AVKit.h>

#define SHARE_URL @""
#define APPLE_MUSIC_URL @"https://music.apple.com/us/album/i-3-u-so/442021273?i=442021277"
#define SPOTIFY_URL @"https://open.spotify.com/track/0WWBeDKdXmGbZD1XVOVqot"
#define YOUTUBE_MUSIC_URL @"https://music.youtube.com/watch?v=_jwVM3vdJ8k"
// If defined, skips the loading screen
//#define SKIP_LOADING_SCREEN

@implementation ViewController

@synthesize loaderPlayer;
@synthesize skipLoadingScreen;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector: @selector(didEnterBackground:)
    name: UIApplicationDidEnterBackgroundNotification
    object: [UIApplication sharedApplication]
    ];

    [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector: @selector(willEnterForeground:)
    name: UIApplicationWillEnterForegroundNotification
    object: [UIApplication sharedApplication]
    ];

    #ifdef SKIP_LOADING_SCREEN
    [self setSkipLoadingScreen: YES];
    #endif

    if([self skipLoadingScreen] == NO) {
        [self->background setHidden: YES];
        [self->contents setHidden: YES];

        NSURL *loaderURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"Loader" ofType: @"m4v"]];
        AVPlayer *player = [AVPlayer playerWithURL:loaderURL];
        self.loaderPlayer = [AVPlayerLayer playerLayerWithPlayer:player];
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];

        [self.loaderPlayer setFrame: [[self view] bounds]];

        [[NSNotificationCenter defaultCenter]
        addObserver: self
        selector: @selector(loaderDidFinish:)
        name: AVPlayerItemDidPlayToEndTimeNotification
        object: [[self.loaderPlayer player] currentItem]
        ];

        [self.view.layer addSublayer: self.loaderPlayer];
        [[self.loaderPlayer player] play];
    }
    else {
        // Skip the loading screen if the video has ended
        [self->background setHidden: NO];
        [self->contents setHidden: NO];
    }
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)play {
    UIStoryboard* currentStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController* vc = [currentStoryboard instantiateViewControllerWithIdentifier: @"VideosViewController"];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController: vc];
}

- (IBAction)share {
    // Opens a share screen with a link of this project
    NSURL *url = [NSURL URLWithString: SHARE_URL];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIAlertAction*)generateStreamingButton: (NSString*)name url:(NSString*)url {
    return [UIAlertAction
            actionWithTitle: name
            style: UIAlertActionStyleDefault
            handler:^(UIAlertAction * _Nonnull action) {
                NSURL *streaming_url = [NSURL URLWithString: url];
                [[UIApplication sharedApplication] openURL: streaming_url options:@{} completionHandler: nil];
            }
    ];
}

- (IBAction)listen {
    // Show a list of streaming services
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose your streaming service"
                                   message:nil
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle: @"Cancel"
                                style: UIAlertActionStyleCancel
                                handler:nil
    ];
    [alert addAction: [self generateStreamingButton: @"Spotify" url: SPOTIFY_URL]];
    [alert addAction: [self generateStreamingButton: @"Apple Music" url: APPLE_MUSIC_URL]];
    [alert addAction: [self generateStreamingButton: @"YouTube Music" url: YOUTUBE_MUSIC_URL]];
    [alert addAction: cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didEnterBackground:(NSNotification *)notification {
    if(self.loaderPlayer != nil) {
        [[self.loaderPlayer player] pause];
    }
}

- (void)willEnterForeground:(NSNotification *)notification {
    if(self.loaderPlayer != nil) {
        [[self.loaderPlayer player] play];
    }
}

- (void)loaderDidFinish:(NSNotification *)notification {
    // Show all elements
    [self->background setHidden: NO];
    [self->contents setHidden: NO];
    // Smooth disappear animation of the loader screen
    [CATransaction begin];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.duration = 0.2;
    [CATransaction setCompletionBlock:^{
        [self.loaderPlayer removeFromSuperlayer];
        self.loaderPlayer = nil;
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }];
    [self.loaderPlayer addAnimation:animation forKey:@"disappear"];
    [self.loaderPlayer setHidden:YES];
    [CATransaction commit];
}

-(BOOL)prefersHomeIndicatorAutoHidden {
    // Show the navigation bar on the bottom of the screen only when the
    // loading video has been shown
    if(self.loaderPlayer != nil) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
