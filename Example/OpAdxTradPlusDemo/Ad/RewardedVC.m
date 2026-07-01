//
//  RewardedVC.m
//  OpAdxTradPlusDemo
//

#import "RewardedVC.h"
#import <TradPlusAds/TradPlusAdRewarded.h>

static NSString * const kRewardedPlacementId = @"29BDECB566DA4F015D937DB7F639C822";

@interface RewardedVC () <TradPlusADRewardedDelegate>
@property (nonatomic, strong) TradPlusAdRewarded *rewardedAd;
@property (nonatomic, strong) UILabel *logLabel;
@end

@implementation RewardedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.rewardedAd = [[TradPlusAdRewarded alloc] init];
    self.rewardedAd.delegate = self;
    [self.rewardedAd setAdUnitID:kRewardedPlacementId];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 80)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载，再点击 Show 观看激励视频";
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
    [self.rewardedAd loadAd];
}

- (void)showAd {
    if (self.rewardedAd.isAdReady) {
        [self.rewardedAd showAdWithSceneId:nil];
    } else {
        self.logLabel.text = @"请先 Load 成功后再 Show";
    }
}

#pragma mark - TradPlusADRewardedDelegate
- (void)tpRewardedAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"激励视频加载成功";
}
- (void)tpRewardedAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
}
- (void)tpRewardedAdReward:(NSDictionary *)adInfo {
    self.logLabel.text = @"已获得奖励";
}
- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo {
    self.logLabel.text = @"激励视频已关闭";
}

@end
