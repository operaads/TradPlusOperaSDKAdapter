#import "NativeC2SBidingVC.h"
#import <TradPlusAds/TradPlusAdNative.h>
#import "OperaNativeCardView.h"

static NSString * const kNativeC2SPlacementId = @"04E29B7952AA40130ED72309E8628122";
static NSString * const kOpAdxTradPlusC2SPriceEventNotification = @"OpAdxTradPlusC2SPriceEventNotification";

@interface NativeC2SBidingVC ()<TradPlusADNativeDelegate>
@property (nonatomic, strong) TradPlusAdNative *nativeAd;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong) UITextView *flowTextView;
@property (nonatomic, assign) double lastBidPricePerImpression;
@property (nonatomic, assign) double lastReportedPricePerImpression;
@end

@implementation NativeC2SBidingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 60)];
    _logLabel.numberOfLines = 0;
    _logLabel.text = @"点击 Load 加载 C2S 原生，再点击 Show 展示";
    [self.view addSubview:_logLabel];

    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadBtn setTitle:@"Load" forState:UIControlStateNormal];
    loadBtn.frame = CGRectMake(20, 170, 100, 44);
    [loadBtn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];

    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBtn setTitle:@"Show" forState:UIControlStateNormal];
    showBtn.frame = CGRectMake(140, 170, 100, 44);
    [showBtn addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];

    CGFloat inset = 40.0;
    _adContainer = [[UIView alloc] initWithFrame:CGRectMake(inset, 230, self.view.bounds.size.width - inset * 2, 260)];
    _adContainer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:_adContainer];

    _flowTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 500, self.view.bounds.size.width - 40, self.view.bounds.size.height - 520)];
    _flowTextView.editable = NO;
    _flowTextView.font = [UIFont systemFontOfSize:12];
    _flowTextView.layer.borderWidth = 1;
    _flowTextView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    _flowTextView.text = @"[流程日志]\n";
    [self.view addSubview:_flowTextView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleC2SPriceEvent:) name:kOpAdxTradPlusC2SPriceEventNotification object:nil];
}

- (void)loadAd {
    if (!self.nativeAd) {
        self.nativeAd = [[TradPlusAdNative alloc] init];
        self.nativeAd.delegate = self;
        [self.nativeAd setAdUnitID:kNativeC2SPlacementId];
    }
    self.logLabel.text = @"原生加载中...";
    self.lastBidPricePerImpression = 0;
    self.lastReportedPricePerImpression = 0;
    for (UIView *v in self.adContainer.subviews) {
        [v removeFromSuperview];
    }
    [self appendFlowLog:@"点击 Load，开始请求竞价原生"];
    [self.nativeAd loadAd];
}

- (void)showAd {
    [self appendFlowLog:[NSString stringWithFormat:@"点击 Show，isAdReady=%@", self.nativeAd.isAdReady ? @"YES" : @"NO"]];
    if (!self.nativeAd || !self.nativeAd.isAdReady) {
        self.logLabel.text = @"暂无可展示原生，请先 Load";
        return;
    }
    for (UIView *v in self.adContainer.subviews) {
        [v removeFromSuperview];
    }
    [self.nativeAd showADWithRenderingViewClass:[OperaNativeCardView class] subview:self.adContainer sceneId:nil];
    self.logLabel.text = @"原生展示中";
    [self appendFlowLog:@"调用 showADWithRenderingViewClass"];
}

- (void)tpNativeAdBidStart:(NSDictionary *)adInfo {
    [self appendFlowLog:[NSString stringWithFormat:@"开始竞价 adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpNativeAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error {
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

- (void)tpNativeAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"原生加载成功，可点击 Show 展示";
    [self appendFlowLog:[NSString stringWithFormat:@"Loaded adInfo=%@", [self compactJSONStringFromObject:adInfo]]];
}

- (void)tpNativeAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"原生加载失败: %@", error.localizedDescription];
    [self appendFlowLog:[NSString stringWithFormat:@"加载失败 code=%ld msg=%@",
                         (long)error.code, error.localizedDescription ?: @""]];
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
