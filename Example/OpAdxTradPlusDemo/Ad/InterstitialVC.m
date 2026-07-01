//
//  InterstitialVC.m
//  OpAdxTradPlusDemo
//

#import "InterstitialVC.h"
#import <TradPlusAds/TradPlusAdInterstitial.h>

static NSString * const kInterstitialPlacementId = @"E76EA94E0FA8F583F9D0679F816A0822";

@interface InterstitialVC () <TradPlusADInterstitialDelegate>
@property (nonatomic, strong) TradPlusAdInterstitial *interstitial;
@property (nonatomic, strong) UILabel *logLabel;
@end

@implementation InterstitialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interstitial = [[TradPlusAdInterstitial alloc] init];
    self.interstitial.delegate = self;
    [self.interstitial setAdUnitID:kInterstitialPlacementId];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 80)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载，再点击 Show 展示插屏";
    [self.view addSubview:_logLabel];

    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadBtn setTitle:@"Load" forState:UIControlStateNormal];
    loadBtn.frame = CGRectMake(20, 200, 100, 44);
    [loadBtn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];

    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBtn setTitle:@"Show" forState:UIControlStateNormal];
    showBtn.frame = CGRectMake(140, 200, 100, 44);
    [showBtn addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
}

- (void)loadAd {
    self.logLabel.text = @"加载中...";
    [self.interstitial loadAd];
}

- (void)showAd {
    if (self.interstitial.isAdReady) {
        [self.interstitial showAdWithSceneId:nil];
    } else {
        self.logLabel.text = @"请先 Load 成功后再 Show";
    }
}

#pragma mark - TradPlusADInterstitialDelegate
- (void)tpInterstitialAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"插屏加载成功";
}
- (void)tpInterstitialAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
}
- (void)tpInterstitialAdDismissed:(NSDictionary *)adInfo {
    self.logLabel.text = @"插屏已关闭";
}

@end
