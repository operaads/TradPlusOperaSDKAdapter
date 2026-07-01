#import "RewardedC2SBidingVC.h"
#import <TradPlusAds/TradPlusAdRewarded.h>

static NSString * const kRewardedC2SPlacementId = @"36999D8D547DA85C7E9A80D023AEB922";
static NSString * const kOpAdxTradPlusC2SPriceEventNotification = @"OpAdxTradPlusC2SPriceEventNotification";

@interface RewardedC2SBidingVC ()<TradPlusADRewardedDelegate>
@property (nonatomic, strong) TradPlusAdRewarded *rewardedAd;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UITextView *flowTextView;
@property (nonatomic, assign) double lastBidPricePerImpression;
@property (nonatomic, assign) double lastReportedPricePerImpression;
@end

@implementation RewardedC2SBidingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.rewardedAd = [[TradPlusAdRewarded alloc] init];
    self.rewardedAd.delegate = self;
    [self.rewardedAd setAdUnitID:kRewardedC2SPlacementId];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 60)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载C2S激励，再点击 Show 展示";
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

    _flowTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 260, self.view.bounds.size.width - 40, self.view.bounds.size.height - 280)];
    _flowTextView.editable = NO;
    _flowTextView.font = [UIFont systemFontOfSize:12];
    _flowTextView.layer.borderWidth = 1;
    _flowTextView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    _flowTextView.text = @"[流程日志]\n";
    [self.view addSubview:_flowTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleC2SPriceEvent:) name:kOpAdxTradPlusC2SPriceEventNotification object:nil];
}

- (void)loadAd {
    self.logLabel.text = @"加载中...";
    self.lastBidPricePerImpression = 0;
    self.lastReportedPricePerImpression = 0;
    [self appendFlowLog:@"点击 Load，开始请求竞价激励"];
    [self.rewardedAd loadAd];
}

- (void)showAd {
    [self appendFlowLog:[NSString stringWithFormat:@"点击 Show，isAdReady=%@", self.rewardedAd.isAdReady ? @"YES" : @"NO"]];
    if (self.rewardedAd.isAdReady) {
        [self.rewardedAd showAdWithSceneId:nil];
        [self appendFlowLog:@"调用 showAdWithSceneId:nil"];
    } else {
        self.logLabel.text = @"请先 Load 成功后再 Show";
        [self appendFlowLog:@"Show 失败：广告未 ready"];
    }
}

- (void)tpRewardedAdBidStart:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"开始竞价 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpRewardedAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error {
    double pricePerImpression = [self extractPricePerImpressionFromAdInfo:adInfo];
    if (pricePerImpression > 0) {
        self.lastBidPricePerImpression = pricePerImpression;
    }
    if (error == nil) {
        [self appendFlowLog:[NSString stringWithFormat:@"竞价成功｜回传价(每次)=%@｜折算eCPM(每千次)=%@",
                             [self formatPrice:pricePerImpression],
                             [self formatPrice:pricePerImpression * 1000.0]]];
    } else {
        [self appendFlowLog:[NSString stringWithFormat:@"竞价失败 code=%ld msg=%@",
                             (long)error.code, error.localizedDescription ?: @""]];
    }
}

- (void)tpRewardedAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"激励加载成功";
    [self appendFlowLog:[NSString stringWithFormat:@"Loaded adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpRewardedAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
    [self appendFlowLog:[NSString stringWithFormat:@"加载失败 code=%ld msg=%@",
                         (long)error.code, error.localizedDescription ?: @""]];
}

- (void)tpRewardedAdReward:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"发放奖励 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo {
    self.logLabel.text = @"激励视频已关闭";
    [self appendFlowLog:[NSString stringWithFormat:@"广告关闭 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)handleC2SPriceEvent:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo ?: @{};
    double tradplusPricePerImpression = [userInfo[@"tradplusPricePerImpression"] doubleValue];
    self.lastReportedPricePerImpression = tradplusPricePerImpression;
    [self appendFlowLog:[NSString stringWithFormat:@"上报给TradPlus价格(每次)=%@",
                         [self formatPrice:tradplusPricePerImpression]]];
}

- (void)appendFlowLog:(NSString *)message {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss.SSS";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *line = [NSString stringWithFormat:@"[%@] %@\n", time, message ?: @""];
    self.flowTextView.text = [self.flowTextView.text stringByAppendingString:line];
    NSRange range = NSMakeRange(self.flowTextView.text.length - 1, 1);
    [self.flowTextView scrollRangeToVisible:range];
}

- (NSString *)compactJSONStringFromObject:(id)obj {
    if (obj == nil) {
        return @"{}";
    }
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return [obj description];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json ?: [obj description];
}

- (double)extractPricePerImpressionFromAdInfo:(NSDictionary *)adInfo {
    NSArray<NSString *> *candidateKeys = @[@"ecpm", @"adsource_price", @"price", @"bid_price", @"networkEcpm", @"network_ecpm"];
    for (NSString *key in candidateKeys) {
        id value = adInfo[key];
        if ([value respondsToSelector:@selector(doubleValue)]) {
            double number = [value doubleValue];
            if (number > 0) {
                return number;
            }
        }
    }
    return 0;
}

- (NSString *)formatPrice:(double)value {
    if (value <= 0) {
        return @"N/A";
    }
    return [NSString stringWithFormat:@"%.6f", value];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
