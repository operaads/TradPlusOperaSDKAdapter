# TradPlusOperaSDKAdapter

Opera Ads SDK 的 TradPlus 聚合平台自定义适配器。

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TradPlusOperaSDKAdapter.svg)](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
[![Platform](https://img.shields.io/cocoapods/p/TradPlusOperaSDKAdapter.svg?style=flat)](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
[![License](https://img.shields.io/cocoapods/l/TradPlusOperaSDKAdapter.svg?style=flat)](https://github.com/operaads/TradPlusOperaSDKAdapter/blob/main/LICENSE)

[English](README_EN.MD) | 简体中文

## 概述

TradPlusOperaSDKAdapter 是一个自定义聚合适配器，使 Opera Advertising SDK (OpAdxSdk) 能够与 TradPlus 聚合平台无缝集成。该适配器将 Opera Ads SDK 的回调桥接到 TradPlus 的聚合回调，实现通过 TradPlus 平台进行广告投放。

## 支持的广告格式

- ✅ Banner 广告（标准、MREC）
- ✅ 插屏广告（Interstitial）
- ✅ 激励广告（Rewarded）
- ✅ 原生广告（Native）
- ✅ 开屏广告（Splash/App Open）

## 版本要求

- iOS 13.0+
- TradPlus SDK 15.1.1+
- OpAdxSdk 2.11.2
- Xcode 16.0+

## 安装

### CocoaPods

在您的 `Podfile` 中添加：

```ruby
# TradPlus SDK
pod 'TradPlusAdSDK', '>= 15.1.1'

# Opera Ads SDK
pod 'OpAdxSdk', '2.11.2'

# Opera Ads TradPlus 适配器
pod 'TradPlusOperaSDKAdapter', '2.11.2.1'
```

然后运行：

```bash
pod install
```

## 快速开始

### 1. 初始化 TradPlus SDK

```objective-c
#import <TradPlusAds/TradPlus.h>

// 在 AppDelegate 中初始化
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 初始化 TradPlus SDK
    [TradPlus initSDK:@"your_tradplus_app_id" completionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"TradPlus 初始化失败: %@", error);
        } else {
            NSLog(@"TradPlus SDK 初始化成功");
        }
    }];

    // Opera Ads SDK 会通过适配器自动初始化

    return YES;
}
```

### 2. 配置自定义广告网络

在 TradPlus 后台配置：

1. 进入 **高级设置** → **自定义广告平台**
2. 点击 **添加广告平台**
3. 填写广告平台名称，并为每种广告格式配置对应的适配器类名

**各广告格式的适配器类名（iOS Adapter Class Name）**：

| 广告格式 | 适配器类名 |
|:---------|:----------|
| Banner | `OpAdxTradPlusBannerAdapter` |
| Interstitial | `OpAdxTradPlusInterstitialAdapter` |
| Rewarded | `OpAdxTradPlusRewardedAdapter` |
| Native | `OpAdxTradPlusNativeAdapter` |
| Splash (App Open) | `OpAdxTradPlusSplashAdapter` |

### 3. 关联广告位

添加自定义广告平台后，将其关联到广告位：

1. 进入 **应用管理** → **应用与广告位**
2. 选择应用和目标广告位
3. 点击 **添加广告源**
4. 选择 Opera Ads 自定义广告平台，填写自定义参数

**自定义参数（Custom Parameters）** - JSON格式：
```json
{
  "appId": "your_opera_app_id",
  "placementId": "your_opera_placement_id",
  "bundleId": "your_bundle_id"
}
```

| 参数 | 必填 | 说明 |
|-----|------|-----|
| `appId` | 是 | Opera Ads 应用 ID（格式：`pub{}/ep{}/app{}`） |
| `placementId` | 是 | Opera Ads 广告位 ID（格式：`s{}`） |
| `bundleId` | 是 | App 在苹果商店的数字 ID |

### 4. Banner 尺寸配置

为 Banner 广告位添加广告源时，在 TradPlus 后台设置正确的尺寸：

- **BANNER**：`320x50`
- **MREC**：`300x250`

### 5. 加载和展示广告

使用 TradPlus 标准 API 加载和展示广告：

#### Banner 广告

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
    NSLog(@"Banner 加载成功");
}

- (void)tpBannerAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"Banner 加载失败: %@", error);
}

- (void)tpBannerAdImpression:(NSDictionary *)adInfo {
    NSLog(@"Banner 展示");
}

- (void)tpBannerAdClicked:(NSDictionary *)adInfo {
    NSLog(@"Banner 点击");
}

@end
```

#### 插屏广告

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
    NSLog(@"插屏广告加载成功");
}

- (void)tpInterstitialAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"插屏广告加载失败: %@", error);
}

- (void)tpInterstitialAdImpression:(NSDictionary *)adInfo {
    NSLog(@"插屏广告展示");
}

- (void)tpInterstitialAdClicked:(NSDictionary *)adInfo {
    NSLog(@"插屏广告点击");
}

- (void)tpInterstitialAdDismissed:(NSDictionary *)adInfo {
    NSLog(@"插屏广告关闭");
}

@end
```

#### 激励广告

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
    NSLog(@"激励广告加载成功");
}

- (void)tpRewardedAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"激励广告加载失败: %@", error);
}

- (void)tpRewardedAdImpression:(NSDictionary *)adInfo {
    NSLog(@"激励广告展示");
}

- (void)tpRewardedAdClicked:(NSDictionary *)adInfo {
    NSLog(@"激励广告点击");
}

- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo {
    NSLog(@"激励广告关闭");
}

- (void)tpRewardedAdReward:(NSDictionary *)adInfo {
    NSLog(@"用户获得奖励");
}

@end
```

#### 原生广告

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
    NSLog(@"原生广告加载成功");
}

- (void)tpNativeAdLoadFailWithError:(NSDictionary *)error {
    NSLog(@"原生广告加载失败: %@", error);
}

- (void)tpNativeAdImpression:(NSDictionary *)adInfo {
    NSLog(@"原生广告展示");
}

- (void)tpNativeAdClicked:(NSDictionary *)adInfo {
    NSLog(@"原生广告点击");
}

@end
```

## C2S（Header Bidding）配置

Opera Ads 支持通过 TradPlus 进行 C2S（Client-to-Server）竞价：

1. 在 TradPlus 后台，进入广告位设置
2. 将 Opera Ads 添加到 **Header Bidding** 分组

适配器会自动处理竞价胜负通知，无需额外代码。

## 版本历史

### 2.11.2.1 (2026-07-01)
- 更新 OpAdxAdapterTradPlus.xcframework

### 2.11.2.0 (2026-06-30)
- 初始版本
- 支持 Banner、Interstitial、Rewarded、Native、Splash 广告格式
- 支持 C2S（Header Bidding）
- 依赖 OpAdxSdk 2.11.2

## 注意事项

### 1. 初始化顺序
Opera Ads SDK 会通过适配器自动初始化，无需手动初始化。

### 2. 适配器类名
TradPlus 要求每种广告格式使用不同的适配器类名，请根据广告格式正确配置。

### 3. 错误处理
所有错误都会通过 TradPlus 的标准错误回调返回，包含详细的错误信息。

### 常见问题

**Q: 广告无法加载？**
A: 检查以下项：
1. TradPlus 后台自定义广告平台配置是否正确
2. 适配器类名是否正确设置
3. 自定义参数（appId、placementId、bundleId）是否正确
4. 查看日志中的详细错误信息

**Q: 适配器类名找不到？**
A: 确保：
1. `TradPlusOperaSDKAdapter` Pod 已正确安装
2. 使用正确的类名（参见上方适配器类名表）
3. 清理并重新构建项目

**Q: Banner 尺寸不正确？**
A: 确保在 TradPlus 后台为 Banner 广告位配置了正确的尺寸（320x50 或 300x250）。

## 示例项目

完整的示例项目请参考：
- [OpAdxSDK Demo - TradPlus Adapter](https://github.com/operaads/iOS-sdk/tree/main/Demo/TradPlusAdapter)

## 技术支持

- 📧 Email: chenl@opera.com
- 📖 文档: [Opera Ads iOS SDK 文档]
- 🐛 问题反馈: [GitHub Issues](https://github.com/operaads/TradPlusOperaSDKAdapter/issues)

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 相关链接

- [Opera Ads SDK](https://github.com/operaads/iOS-sdk)
- [TradPlus 文档](https://docs.tradplusad.com/)
- [CocoaPods](https://cocoapods.org/pods/TradPlusOperaSDKAdapter)
