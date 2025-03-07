

#import "AppController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "SDKWrapper.h"
#import "platform/ios/CCEAGLView-ios.h"
#import <Adjust/Adjust.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

static RootViewController* rootViewController = nullptr;

using namespace cocos2d;

@implementation AppController

Application* app = nullptr;

#pragma mark -
#pragma mark Application lifecycle

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SDKWrapper getInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    float scale = [[UIScreen mainScreen] scale];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    app = new AppDelegate(bounds.size.width * scale, bounds.size.height * scale);
    app->setMultitouch(true);
    app->start();
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    return YES;
}

+ (UIViewController *)rootViewController
{
    if (rootViewController) {
        return rootViewController;
    } else {
        NSLog(@"rootViewController is not initialized!");
        rootViewController = [[RootViewController alloc] init];
        return rootViewController;
    }
}

- (void)requestIDFA {
  [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
  }];
}

+ (void)applicationWillResignActive:(UIApplication *)application {
    app->onPause();
    [[SDKWrapper getInstance] applicationWillResignActive:application];
}

+ (void)applicationDidBecomeActive:(UIApplication *)application {
    app->onResume();
    [[SDKWrapper getInstance] applicationDidBecomeActive:application];
}

+ (void)applicationDidEnterBackground:(UIApplication *)application {
    [[SDKWrapper getInstance] applicationDidEnterBackground:application];
}

+ (void)applicationWillEnterForeground:(UIApplication *)application {
    [[SDKWrapper getInstance] applicationWillEnterForeground:application];
}

+ (void)applicationWillTerminate:(UIApplication *)application
{
    [[SDKWrapper getInstance] applicationWillTerminate:application];
    delete app;
    app = nil;
}

+ (void)champs
{
    NSLog(@"champs");
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PokerStreakNavigationController"];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self rootViewController] presentViewController:nav animated:NO completion:nil];
}

@end
