//
//  SplashVC.m
//  OpAdxTradPlusDemo
//

#import "SplashVC.h"
#import <TradPlusAds/TradPlusAdSplash.h>

// 替换为你在 TradPlus 后台创建的开屏广告位 ID
static NSString * const kSplashPlacementId = @"96CF65BD19006E2E5B51F706355CEF22";

@interface SplashVC () <TradPlusADSplashDelegate>
@property (nonatomic, strong) TradPlusAdSplash *splashAd;
@property (nonatomic, strong) UILabel *logLabel;
@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.splashAd = [[TradPlusAdSplash alloc] init];
    self.splashAd.delegate = self;
    [self.splashAd setAdUnitID:kSplashPlacementId];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 60)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载，再点击 Show 展示";
    [self.view addSubview:_logLabel];

    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadBtn setTitle:@"Load" forState:UIControlStateNormal];
    loadBtn.frame = CGRectMake(20, 180, 100, 44);
    [loadBtn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];

    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBtn setTitle:@"Show" forState:UIControlStateNormal];
    showBtn.frame = CGRectMake(140, 180, 100, 44);
    [showBtn addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
}

- (void)loadAd {
    self.logLabel.text = @"加载中...";
    [self.splashAd loadAdWithWindow:[UIApplication sharedApplication].keyWindow bottomView:nil];
}

- (void)showAd {
    if (self.splashAd.isAdReady) {
        [self.splashAd show];
    } else {
        self.logLabel.text = @"请先 Load 成功后再 Show";
    }
}

#pragma mark - TradPlusADSplashDelegate
- (void)tpSplashAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"加载成功";
}
- (void)tpSplashAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
}
- (void)tpSplashAdDismissed:(NSDictionary *)adInfo {
    self.logLabel.text = @"开屏已关闭";
}

@end
