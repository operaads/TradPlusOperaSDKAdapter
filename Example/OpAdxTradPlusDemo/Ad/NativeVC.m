//
//  NativeVC.m
//  OpAdxTradPlusDemo
//
//  简化版原生广告：加载后展示在列表上方。完整模板可参考 tradplus-ios-demo-main 的 TradPlusAdNativeViewController.
//

#import "NativeVC.h"
#import <TradPlusAds/TradPlusAdNative.h>
#import <TradPlusAds/TradPlusNativeBannerTemplate.h>
#import "OperaNativeCardView.h"

static NSString * const kNativePlacementId = @"35E5D4A0E3735426A9D0ECC5F754D722";

@interface NativeVC () <TradPlusADNativeDelegate>
@property (nonatomic, strong) TradPlusAdNative *nativeAd;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UIView *adContainer;
@end

@implementation NativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 60)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载原生广告";
    [self.view addSubview:_logLabel];

    CGFloat inset = 40.0;
    _adContainer = [[UIView alloc] initWithFrame:CGRectMake(inset, 180, self.view.bounds.size.width - inset * 2, 300)];
    _adContainer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:_adContainer];

    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadBtn setTitle:@"Load Native" forState:UIControlStateNormal];
    loadBtn.frame = CGRectMake(20, 500, 140, 44);
    [loadBtn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];

    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBtn setTitle:@"Show Native" forState:UIControlStateNormal];
    showBtn.frame = CGRectMake(180, 500, 140, 44);
    [showBtn addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];

    // 不在此处创建 nativeAd，进入页面不自动加载，仅当点击 Load 时再创建并加载
}

// 点击 Load：仅触发加载，不立即渲染
- (void)loadAd {
    if (!self.nativeAd) {
        self.nativeAd = [[TradPlusAdNative alloc] init];
        self.nativeAd.delegate = self;
        [self.nativeAd setAdUnitID:kNativePlacementId];
    }
    self.logLabel.text = @"原生加载中...";
    for (UIView *v in _adContainer.subviews) { [v removeFromSuperview]; }
    [self.nativeAd loadAd];
}

// 点击 Show：展示已加载的原生广告
- (void)showAd {
    if (!self.nativeAd || !self.nativeAd.isAdReady) {
        self.logLabel.text = @"暂无可展示的原生广告，请先 Load";
        return;
    }
    self.logLabel.text = @"原生展示中";
    for (UIView *v in _adContainer.subviews) { [v removeFromSuperview]; }
    // 使用自定义纯代码卡片布局的原生 View 进行渲染展示
    [self.nativeAd showADWithRenderingViewClass:[OperaNativeCardView class]
                                        subview:_adContainer
                                        sceneId:nil];
}

#pragma mark - TradPlusADNativeDelegate

- (void)tpNativeAdLoaded:(NSDictionary *)adInfo {
    // 有广告缓存成功，但不立刻展示，等用户点 Show 再展示
    self.logLabel.text = @"原生加载成功，可点击 Show 展示";
}

- (void)tpNativeAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"原生加载失败: %@", error.localizedDescription];
}

@end
