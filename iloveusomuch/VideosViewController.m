#import <Foundation/Foundation.h>
#import "VideosViewController.h"
#import "ViewController.h"

#define ANIMATION_DURATION 0.3
#define ANIMATION_CURVE UIViewAnimationOptionCurveEaseOut
#define CROP_VIDEOS_PX 2

@implementation VideoView
@synthesize videosPlayer;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // If the video was paused (by playing music, incoming call, etc) we can start
    // playing it by touching
    AVPlayer* player = [[self videosPlayer] player];
    if ((player.rate == 0) || (player.error != nil)) {
        [player play];
    }

    if([touches count] == 1) {
        self->swipeXStart = [[touches anyObject] locationInView: self].x;
        self->posXStart = [self.videosPlayer frame].origin.x;
        self->swipeYStart = [[touches anyObject] locationInView: self].y;
        self->posYStart = [self.videosPlayer frame].origin.y;
        self->swiping = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Handle situations when a popup appeared or when a user is accessing a
    // notification tray and scrolling the video at the same time
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self->swiping == NO || [touches count] != 1) {
        return;
    }

    CGRect bounds = [self.videosPlayer bounds];
    float x = [[touches anyObject] locationInView: self].x - self->swipeXStart;

    float xForIf = x + self->posXStart;
    if(xForIf <= 0.0) {
        if (xForIf < [self bounds].size.width - [self.videosPlayer frame].size.width) {
            x = 0;
        }
    } else {
        x = 0;
    }

    float y = [[touches anyObject] locationInView: self].y - self->swipeYStart;

    float yForIf = y + self->posYStart;
    if(yForIf <= 0.0) {
        if (yForIf < [self bounds].size.height - [self.videosPlayer frame].size.height) {
            y = 0;
        }
    } else {
        y = 0;
    }

    float newX = x + self->posXStart;
    float newY = y + self->posYStart;

    CGRect newFrame;
    newFrame.origin.x = newX;
    newFrame.origin.y = newY;
    newFrame.size.width = bounds.size.width;
    newFrame.size.height = bounds.size.height;

    [self.videosPlayer setFrame: newFrame];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self->swiping == NO || [touches count] != 1) {
        return;
    }

    // User clicked twice
    if([[[touches allObjects] objectAtIndex: 0] tapCount] == 2) {
        self->swiping = NO;

        // Not zoomed yet, zooming in
        if(!self->zoomed) {
            CGPoint touchPoint = [(UITouch*)[touches anyObject] locationInView: self];
            CGPoint point = [[self videosPlayer] convertPoint:touchPoint fromLayer: self.layer];

            float column = floorf(point.x / [self bounds].size.width * 2);
            float row = floorf(point.y / [self bounds].size.height * 2);

            float f1 = -column * [self bounds].size.width;
            float f2 = -row * [self bounds].size.height;

            [UIView
             animateWithDuration: ANIMATION_DURATION
             delay: 0.0
             options: ANIMATION_CURVE
             animations:^{
                    float w1 = [self bounds].size.width * 4;
                    float h1 = [self bounds].size.height * 2;

                    CGRect newFrame;
                    newFrame.origin.x = f1;
                    newFrame.origin.y = f2;
                    newFrame.size.width = w1;
                    newFrame.size.height = h1;

                    [self.videosPlayer setFrame: newFrame];
                }
             completion:^(BOOL finished) {
                    self->zoomed = YES;
                }
            ];
            return;
        }

        // Zooming out
        CGRect videosFrame = [self.videosPlayer frame];
        float newX;

        if(videosFrame.origin.x <= ([self.videosPlayer frame].size.width * -0.5)) {
            newX = -[self bounds].size.width;
        }
        else {
            newX = 0.0;
        }

        [UIView
         animateWithDuration: ANIMATION_DURATION
         delay: 0.0
         options: ANIMATION_CURVE
         animations: ^{
            CGRect newFrame;
            newFrame.origin.x = newX;
            newFrame.origin.y = 0.0;
            newFrame.size.width = [self bounds].size.width * 2;
            newFrame.size.height = [self bounds].size.height;

            [self.videosPlayer setFrame: newFrame];
        }
         completion: ^(BOOL finished) {
            self->zoomed = NO;
        }
        ];
        return;
    }

    CGPoint point1 = [[touches anyObject] locationInView: self];
    float posXSubSwipeX = point1.x - self->swipeXStart;
    float posXAddSub = posXSubSwipeX + self->posXStart;
    if (0.0 < posXAddSub || posXSubSwipeX <= 50.0) {
        if(posXAddSub >= ([self bounds].size.width - [self.videosPlayer frame].size.width)
           && posXSubSwipeX < -50.0) {
            self->posXStart = self->posXStart - [self bounds].size.width;
        }
    }
    else {
        self->posXStart = self->posXStart + [self bounds].size.width;
    }

    float posYSubSwipeY = [[touches anyObject] locationInView: self].y - self->swipeYStart;
    float posYAddSub = posYSubSwipeY + self->posYStart;
    if(0.0 < posYAddSub || posYSubSwipeY <= 50.0) {
        if(posYAddSub >= [self bounds].size.height - [self.videosPlayer frame].size.height
           && posYSubSwipeY < -50.0) {
            self->posYStart = self->posYStart - [self bounds].size.height;
        }
    }
    else {
        self->posYStart = self->posYStart + [self bounds].size.height;
    }

    [UIView
     animateWithDuration: ANIMATION_DURATION
     delay: 0.0
     options: ANIMATION_CURVE
     animations: ^{
        CGRect newFrame;
        newFrame.origin.x = self->posXStart;
        newFrame.origin.y = self->posYStart;
        newFrame.size.width = [self.videosPlayer frame].size.width;
        newFrame.size.height = [self.videosPlayer frame].size.height;

        [self.videosPlayer setFrame: newFrame];
    }
     completion: ^(BOOL finished) {
        self->swiping = NO;
    }
    ];
}
@end


@implementation VideosViewController

@synthesize videosPlayer;
@synthesize videoView;

-(void) viewDidLoad {
    [super viewDidLoad];
    // Pause the video if the app is in background
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector: @selector(didEnterBackground:)
     name: UIApplicationDidEnterBackgroundNotification
     object: nil
     ];

    // Play the video if the app is in foreground
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector: @selector(willEnterForeground:)
     name: UIApplicationWillEnterForegroundNotification
     object: nil
     ];

    NSURL *loaderURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"Videos" ofType: @"m4v"]];
    AVPlayer *player = [AVPlayer playerWithURL:loaderURL];
    [self setVideosPlayer: [AVPlayerLayer playerLayerWithPlayer:player]];
    [[self videoView] setVideosPlayer: [self videosPlayer]];

    // Show the main screen when the video ends
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector: @selector(videosDidFinish:)
     name: AVPlayerItemDidPlayToEndTimeNotification
     object: [[self.videosPlayer player] currentItem]
     ];

    [[self videoView].layer addSublayer: self.videosPlayer];
    [self videoView].clipsToBounds = YES;
}

- (void)viewDidLayoutSubviews {
    // Adjust the video frame before showing the view
    [super viewDidLayoutSubviews];
    CGRect bounds = [[self videoView] bounds];
    CGRect newBounds;
    newBounds.origin.x = 0;
    newBounds.origin.y = 0;
    newBounds.size.width = bounds.size.width * 2;
    newBounds.size.height = bounds.size.height;

    // Allow playing music in silent mode & avoid mixing it with other audio
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                error: nil];
    [self.videosPlayer setFrame: newBounds];

    // Videos are not perfectly aligned. When zoomed in, sometimes there are visible lines
    // of adjacent videos on the endges. We can set a mask, to hide some pixels from each side
    CAShapeLayer* levelLayer = [CAShapeLayer layer];
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:
                          CGRectMake([[self videoView] bounds].origin.x + CROP_VIDEOS_PX,
                           [[self videoView] bounds].origin.y + CROP_VIDEOS_PX,
                           [[self videoView] bounds].size.width - CROP_VIDEOS_PX * 2,
                           [[self videoView] bounds].size.height - CROP_VIDEOS_PX * 2)
    ];
    [levelLayer setPath: path.CGPath];
    [[[self videoView] layer] setMask: levelLayer];

    [[self.videosPlayer player] play];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)didEnterBackground:(NSNotification *)notification
{
    [[self.videosPlayer player] pause];
}

-(void)willEnterForeground:(NSNotification *)notification
{
    [[self.videosPlayer player] play];
}

- (void)videosDidFinish:(NSNotification *)notification
{
    // Remove the player and show the main view
    [self.videosPlayer removeFromSuperlayer];
    self.videosPlayer = nil;
    [[self videoView] setVideosPlayer: nil];
    UIStoryboard* currentStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController* vc = [currentStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
    [vc setSkipLoadingScreen: YES];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController: vc];
}

-(BOOL)prefersHomeIndicatorAutoHidden {
    // This method should avoid showing the navigation bar on the bottom of the screen
    return YES;
}

@end
