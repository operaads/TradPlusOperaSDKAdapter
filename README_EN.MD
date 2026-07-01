# TradPlusOperaSDKAdapter

Custom adapter for integrating Opera Ads SDK with TradPlus mediation platform.

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TradPlusOperaSDKAdapter.svg)](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
[![Platform](https://img.shields.io/cocoapods/p/TradPlusOperaSDKAdapter.svg?style=flat)](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
[![License](https://img.shields.io/cocoapods/l/TradPlusOperaSDKAdapter.svg?style=flat)](https://github.com/operaads/TradPlusOperaSDKAdapter/blob/main/LICENSE)

English | [简体中文](README.MD)

## Overview

TradPlusOperaSDKAdapter is a custom mediation adapter that enables seamless integration of Opera Advertising SDK (OpAdxSdk) with the TradPlus mediation platform. This adapter bridges Opera Ads SDK callbacks to TradPlus mediation callbacks, enabling ad serving through the TradPlus platform.

## Supported Ad Formats

- ✅ Banner Ads (Standard, MREC)
- ✅ Interstitial Ads
- ✅ Rewarded Ads
- ✅ Native Ads
- ✅ Splash/App Open Ads

## Requirements

- iOS 13.0+
- TradPlus SDK 15.1.1+
- OpAdxSdk 2.11.2
- Xcode 16.0+

## Installation

### CocoaPods

Add the following to your `Podfile`:

```ruby
# TradPlus SDK
pod 'TradPlusAdSDK', '>= 15.1.1'

# Opera Ads SDK
pod 'OpAdxSdk', '2.11.2'

# Opera Ads TradPlus Adapter
pod 'TradPlusOperaSDKAdapter', '2.11.2.1'
```

Then run:

```bash
pod install
```

## Quick Start

### 1. Initialize TradPlus SDK

```objective-c
#import <TradPlusAds/TradPlus.h>

// Initialize in AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Initialize TradPlus SDK
    [TradPlus initSDK:@"your_tradplus_app_id" completionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"TradPlus initialization failed: %@", error);
        } else {
            NSLog(@"TradPlus SDK initialized");
        }
    }];

    // Opera Ads SDK will be auto-initialized by the adapter

    return YES;
}
```

### 2. Configure Custom Ad Network

In the TradPlus dashboard:

1. Navigate to **Advanced Settings** → **Custom Networks**
2. Click **Add Networks**
3. Fill in the network name and configure the adapter class name for each ad format

**Adapter Class Names for Each Ad Format (iOS Adapter Class Name)**:

| Ad Format | Adapter Class Name |
|:----------|:-------------------|
| Banner | `OpAdxTradPlusBannerAdapter` |
| Interstitial | `OpAdxTradPlusInterstitialAdapter` |
| Rewarded | `OpAdxTradPlusRewardedAdapter` |
| Native | `OpAdxTradPlusNativeAdapter` |
| Splash (App Open) | `OpAdxTradPlusSplashAdapter` |

### 3. Attach to Ad Unit

After adding the custom network, attach it to your ad unit:

1. Navigate to **App Management** → **Apps & Ad Units**
2. Select your app and the target ad unit
3. Click **Add Ad Source**
4. Select Opera Ads custom network and fill in the custom parameters

**Custom Parameters** - JSON format:
```json
{
  "appId": "your_opera_app_id",
  "placementId": "your_opera_placement_id",
  "bundleId": "your_bundle_id"
}
```

| Key | Required | Description |
|-----|----------|-------------|
| `appId` | Yes | Opera Ads Application ID (format: `pub{}/ep{}/app{}`) |
| `placementId` | Yes | Opera Ads Placement ID (format: `s{}`) |
| `bundleId` | Yes | Your iOS App Store ID |

### 4. Banner Size Configuration

When adding an ad source for a Banner ad unit, set the correct size in the TradPlus console:

- **BANNER**: `320x50`
- **MREC**: `300x250`

### 5. Load and Show Ads

Use TradPlus standard APIs to load and show ads:

#### Banner Ads

```objective-c
#import <TradPlusAds/TradPlus.h>

@interface BannerViewController () <TradPlusADBannerDelegate>
@property (nonatomic, strong) TradPlusAdBanner *banner;
@end

@implementation BannerViewController

- (void)loadBanner {
    self.banner = [[TradPlusAdBanner alloc] init];
    self.banner.delegate = self;
    [self.banner setAdUnitID:@"your_tradplus_ad_unit_id"];
    [self.banner loadAdWithSceneId:nil];
}

#pragma mark - TradPlusADBannerDelegate

- (void)tpBannerAdLoaded:(NSDictionary *)adInfo {
    NSLog(@"Banner loaded successfully");
}

- (void)tpBannerAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"Banner failed to load: %@", error);
}

- (void)tpBannerAdImpression:(NSDictionary *)adInfo {
    NSLog(@"Banner displayed");
}

- (void)tpBannerAdClicked:(NSDictionary *)adInfo {
    NSLog(@"Banner clicked");
}

@end
```

#### Interstitial Ads

```objective-c
#import <TradPlusAds/TradPlus.h>

@interface InterstitialViewController () <TradPlusADInterstitialDelegate>
@property (nonatomic, strong) TradPlusAdInterstitial *interstitial;
@end

@implementation InterstitialViewController

- (void)loadInterstitial {
    self.interstitial = [[TradPlusAdInterstitial alloc] init];
    self.interstitial.delegate = self;
    [self.interstitial setAdUnitID:@"your_tradplus_ad_unit_id"];
    [self.interstitial loadAd];
}

- (void)showInterstitial {
    if ([self.interstitial isAdReady]) {
        [self.interstitial showAdFromRootViewController:self];
    }
}

#pragma mark - TradPlusADInterstitialDelegate

- (void)tpInterstitialAdLoaded:(NSDictionary *)adInfo {
    NSLog(@"Interstitial loaded successfully");
}

- (void)tpInterstitialAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"Interstitial failed to load: %@", error);
}

- (void)tpInterstitialAdImpression:(NSDictionary *)adInfo {
    NSLog(@"Interstitial displayed");
}

- (void)tpInterstitialAdClicked:(NSDictionary *)adInfo {
    NSLog(@"Interstitial clicked");
}

- (void)tpInterstitialAdDismissed:(NSDictionary *)adInfo {
    NSLog(@"Interstitial dismissed");
}

@end
```

#### Rewarded Ads

```objective-c
#import <TradPlusAds/TradPlus.h>

@interface RewardedViewController () <TradPlusADRewardedDelegate>
@property (nonatomic, strong) TradPlusAdRewarded *rewarded;
@end

@implementation RewardedViewController

- (void)loadRewarded {
    self.rewarded = [[TradPlusAdRewarded alloc] init];
    self.rewarded.delegate = self;
    [self.rewarded setAdUnitID:@"your_tradplus_ad_unit_id"];
    [self.rewarded loadAd];
}

- (void)showRewarded {
    if ([self.rewarded isAdReady]) {
        [self.rewarded showAdFromRootViewController:self];
    }
}

#pragma mark - TradPlusADRewardedDelegate

- (void)tpRewardedAdLoaded:(NSDictionary *)adInfo {
    NSLog(@"Rewarded ad loaded successfully");
}

- (void)tpRewardedAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"Rewarded ad failed to load: %@", error);
}

- (void)tpRewardedAdImpression:(NSDictionary *)adInfo {
    NSLog(@"Rewarded ad displayed");
}

- (void)tpRewardedAdClicked:(NSDictionary *)adInfo {
    NSLog(@"Rewarded ad clicked");
}

- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo {
    NSLog(@"Rewarded ad dismissed");
}

- (void)tpRewardedAdReward:(NSDictionary *)adInfo {
    NSLog(@"User earned reward");
}

@end
```

#### Native Ads

```objective-c
#import <TradPlusAds/TradPlus.h>

@interface NativeViewController () <TradPlusADNativeDelegate>
@property (nonatomic, strong) TradPlusAdNative *nativeAd;
@end

@implementation NativeViewController

- (void)loadNative {
    self.nativeAd = [[TradPlusAdNative alloc] init];
    self.nativeAd.delegate = self;
    [self.nativeAd setAdUnitID:@"your_tradplus_ad_unit_id"];
    [self.nativeAd loadAd];
}

#pragma mark - TradPlusADNativeDelegate

- (void)tpNativeAdLoaded:(NSDictionary *)adInfo {
    NSLog(@"Native ad loaded successfully");
}

- (void)tpNativeAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"Native ad failed to load: %@", error);
}

- (void)tpNativeAdImpression:(NSDictionary *)adInfo {
    NSLog(@"Native ad displayed");
}

- (void)tpNativeAdClicked:(NSDictionary *)adInfo {
    NSLog(@"Native ad clicked");
}

@end
```

## C2S (Header Bidding) Configuration

Opera Ads supports C2S (Client-to-Server) bidding through TradPlus:

1. In the TradPlus console, navigate to your ad unit
2. Add Opera Ads to the **Header Bidding** group

The adapter handles win/loss notifications automatically. No additional code is required.

## Version History

### 2.11.2.1 (2026-07-01)
- Update OpAdxAdapterTradPlus.xcframework

### 2.11.2.0 (2026-06-30)
- Initial release
- Support for Banner, Interstitial, Rewarded, Native, and Splash ad formats
- Support for C2S (Header Bidding)
- Depends on OpAdxSdk 2.11.2

## Important Notes

### 1. Initialization Order
Opera Ads SDK is automatically initialized through the adapter. No manual initialization is required.

### 2. Adapter Class Names
TradPlus requires a separate adapter class name for each ad format. Make sure to configure the correct class name for each format.

### 3. Error Handling
All errors are returned through TradPlus's standard error callbacks with detailed error information.

### Common Issues

**Q: Ads not loading?**
A: Check the following:
1. Verify custom network configuration in TradPlus dashboard is correct
2. Ensure adapter class names are correctly set
3. Verify custom parameters (appId, placementId, bundleId) are correct
4. Check console logs for detailed error messages

**Q: Adapter class not found?**
A: Make sure:
1. `TradPlusOperaSDKAdapter` Pod is correctly installed
2. Use the correct class names (see adapter class name table above)
3. Clean and rebuild your project

**Q: Banner size incorrect?**
A: Ensure you have configured the correct size (320x50 or 300x250) for the Banner ad unit in TradPlus console.

## Sample Project

For a complete sample project, see:
- [OpAdxSDK Demo - TradPlus Adapter](https://github.com/operaads/iOS-sdk/tree/main/Demo/TradPlusAdapter)

## Technical Support

- 📧 Email: chenl@opera.com
- 📖 Documentation: [Opera Ads iOS SDK Documentation]
- 🐛 Issue Tracker: [GitHub Issues](https://github.com/operaads/TradPlusOperaSDKAdapter/issues)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## Related Links

- [Opera Ads SDK](https://github.com/operaads/iOS-sdk)
- [TradPlus Documentation](https://docs.tradplusad.com/)
- [CocoaPods](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
