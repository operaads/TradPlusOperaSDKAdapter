//
//  AppDelegate.m
//  OpAdxTradPlusDemo
//
//
//

#import "AppDelegate.h"
#import <TradPlusAds/TradPlus.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

// TradPlus 应用 ID（仅初始化 TradPlus SDK，三方 Adapter 由 TradPlus 按类名自动反射调用）
static NSString * const kTradPlusAppId = @"F600DC65211671C89098BD5F36B56321";

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {}];
    }

    // 1. 初始化 TradPlus SDK
    [TradPlus initSDK:kTradPlusAppId completionBlock:^(NSError * _Nonnull error) {
        if (!error) {
            NSLog(@"[OpAdxTradPlusDemo] TradPlus SDK init success");
        } else {
            NSLog(@"[OpAdxTradPlusDemo] TradPlus SDK init error: %@", error);
        }
    }];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self createRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)createRootViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateInitialViewController];
}

@end
