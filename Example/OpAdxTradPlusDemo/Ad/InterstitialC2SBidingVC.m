//
//  InterstitialC2SBidingVC.m
//  OpAdxTradPlusDemo
//
//  Created by xuxiaochuan on 2026/4/29.
//

#import "InterstitialC2SBidingVC.h"
#import <TradPlusAds/TradPlusAdInterstitial.h>

static NSString * const kInterstitialC2SPlacementId = @"6F9AA37AF63A1DEF3C79EC95ECCFE422";
static NSString * const kOpAdxTradPlusC2SPriceEventNotification = @"OpAdxTradPlusC2SPriceEventNotification";
@interface InterstitialC2SBidingVC ()<TradPlusADInterstitialDelegate>
@property (nonatomic, strong) TradPlusAdInterstitial *interstitial;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UITextView *flowTextView;
@property (nonatomic, assign) double lastBidPricePerImpression;
@property (nonatomic, assign) double lastReportedPricePerImpression;
@property (nonatomic, assign) double lastReportedEcpmInMille;
@end

@implementation InterstitialC2SBidingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interstitial = [[TradPlusAdInterstitial alloc] init];
    self.interstitial.delegate = self;
    [self.interstitial setAdUnitID:kInterstitialC2SPlacementId];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 60)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载C2B竞价广告，再点击 Show 展示插屏";
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleC2SPriceEvent:)
                                                 name:kOpAdxTradPlusC2SPriceEventNotification
                                               object:nil];

    [self appendFlowLog:@"页面初始化完成"];
}

- (void)loadAd {
    self.logLabel.text = @"加载中...";
    self.lastBidPricePerImpression = 0;
    self.lastReportedPricePerImpression = 0;
    self.lastReportedEcpmInMille = 0;
    [self appendFlowLog:@"点击 Load，开始请求竞价插屏"];
    [self.interstitial loadAd];
}

- (void)showAd {
    [self appendFlowLog:[NSString stringWithFormat:@"点击 Show，isAdReady=%@", self.interstitial.isAdReady ? @"YES" : @"NO"]];
    if (self.interstitial.isAdReady) {
        [self.interstitial showAdWithSceneId:nil];
        [self appendFlowLog:@"调用 showAdWithSceneId:nil"];
    } else {
        self.logLabel.text = @"请先 Load 成功后再 Show";
        [self appendFlowLog:@"Show 失败：广告未 ready"];
    }
}

#pragma mark - TradPlusADInterstitialDelegate

- (void)tpInterstitialAdBidStart:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"开始竞价 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error {
    double pricePerImpression = [self extractPricePerImpressionFromAdInfo:adInfo];
    if (pricePerImpression > 0) {
        self.lastBidPricePerImpression = pricePerImpression;
    }
    double ecpmInMille = pricePerImpression > 0 ? (pricePerImpression * 1000.0) : 0;
    if (error == nil) {
        [self appendFlowLog:[NSString stringWithFormat:@"竞价成功｜TradPlus回传价(每次)=%@｜折算eCPM(每千次)=%@",
                             [self formatPrice:pricePerImpression],
                             [self formatPrice:ecpmInMille]]];
        if (self.lastReportedPricePerImpression > 0) {
            [self appendFlowLog:[NSString stringWithFormat:@"价格对比｜上报给TradPlus(每次)=%@｜TradPlus回传(每次)=%@",
                                 [self formatPrice:self.lastReportedPricePerImpression],
                                 [self formatPrice:pricePerImpression]]];
        }
    } else {
        [self appendFlowLog:[NSString stringWithFormat:@"竞价失败 code=%ld msg=%@｜最近竞价成功价(每次)=%@｜折算eCPM(每千次)=%@",
                             (long)error.code,
                             error.localizedDescription ?: @"",
                             [self formatPrice:self.lastBidPricePerImpression],
                             [self formatPrice:self.lastBidPricePerImpression * 1000.0]]];
    }
    [self appendFlowLog:[NSString stringWithFormat:@"BidEnd adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdOneLayerStartLoad:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"开始加载三方源 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdOneLayerLoaded:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"单层加载成功 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error {
    [self appendFlowLog:[NSString stringWithFormat:@"单层加载失败 code=%ld msg=%@ adInfo=%@",
                         (long)error.code,
                         error.localizedDescription ?: @"",
                         [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdAllLoaded:(BOOL)success adInfo:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"全部加载结束 success=%@ adInfo=%@",
                         success ? @"YES" : @"NO",
                         [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpInterstitialAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"插屏加载成功";
    double pricePerImpression = [self extractPricePerImpressionFromAdInfo:adInfo];
    if (pricePerImpression > 0) {
        self.lastBidPricePerImpression = pricePerImpression;
    }
    [self appendFlowLog:[NSString stringWithFormat:@"加载成功｜TradPlus价(每次)=%@｜折算eCPM(每千次)=%@",
                         [self formatPrice:self.lastBidPricePerImpression],
                         [self formatPrice:self.lastBidPricePerImpression * 1000.0]]];
    [self appendFlowLog:[NSString stringWithFormat:@"Loaded adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}
- (void)tpInterstitialAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
    [self appendFlowLog:[NSString stringWithFormat:@"加载失败 code=%ld msg=%@｜最近竞价成功价(每次)=%@｜折算eCPM(每千次)=%@",
                         (long)error.code,
                         error.localizedDescription ?: @"",
                         [self formatPrice:self.lastBidPricePerImpression],
                         [self formatPrice:self.lastBidPricePerImpression * 1000.0]]];
}
- (void)tpInterstitialAdLoadFailWithError:(NSError *)error adInfo:(NSDictionary *)adInfo {
    self.logLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
    [self appendFlowLog:[NSString stringWithFormat:@"加载失败(含adInfo) code=%ld msg=%@ adInfo=%@",
                         (long)error.code,
                         error.localizedDescription ?: @"",
                         [self compactJSONStringFromObject:adInfo]]];
}
- (void)tpInterstitialAdImpression:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"曝光成功 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}
- (void)tpInterstitialAdClicked:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"点击广告 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}
- (void)tpInterstitialAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error {
    [self appendFlowLog:[NSString stringWithFormat:@"展示失败 code=%ld msg=%@ adInfo=%@",
                         (long)error.code,
                         error.localizedDescription ?: @"",
                         [self compactJSONStringFromObject:adInfo]]];
}
- (void)tpInterstitialAdDismissed:(NSDictionary *)adInfo {
    self.logLabel.text = @"插屏已关闭";
    [self appendFlowLog:[NSString stringWithFormat:@"广告关闭 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
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

- (void)handleC2SPriceEvent:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo ?: @{};
    double opadxEcpmInMille = [userInfo[@"opadxEcpmInMille"] doubleValue];
    double tradplusPricePerImpression = [userInfo[@"tradplusPricePerImpression"] doubleValue];
    self.lastReportedEcpmInMille = opadxEcpmInMille;
    self.lastReportedPricePerImpression = tradplusPricePerImpression;
    [self appendFlowLog:[NSString stringWithFormat:@"上报给TradPlus｜Opera eCPM(每千次)=%@ -> TradPlus价格(每次)=%@",
                         [self formatPrice:opadxEcpmInMille],
                         [self formatPrice:tradplusPricePerImpression]]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)compactJSONStringFromObject:(id)obj {
    if (obj == nil) {
        return @"{}";
    }
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return [obj description];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    if (data == nil) {
        return [obj description];
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json ?: [obj description];
}

- (double)extractPricePerImpressionFromAdInfo:(NSDictionary *)adInfo {
    if (![adInfo isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
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


@end
