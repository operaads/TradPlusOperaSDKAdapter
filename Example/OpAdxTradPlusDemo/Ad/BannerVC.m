//
//  BannerVC.m
//  OpAdxTradPlusDemo
//

#import "BannerVC.h"
#import <TradPlusAds/TradPlusAdBanner.h>

static NSString * const kBannerPlacementId = @"D82004DF8542BECDD8525CDEB4AB0322";

@interface BannerVC () <TradPlusADBannerDelegate>
@property (nonatomic, strong) TradPlusAdBanner *banner;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *logLabel;
@end

@implementation BannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 40)];
    _logLabel.text = @"Banner 将展示在下方";
    [self.view addSubview:_logLabel];
    _containerView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 300)/2.f,160, 300, 250)];
    _containerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:_containerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.banner) {
        self.banner = [[TradPlusAdBanner alloc] init];
        [self.banner setBannerSize:CGSizeMake(300, 250)];
        [self.banner setAdUnitID:kBannerPlacementId];
        self.banner.delegate = self;
        self.banner.frame = _containerView.bounds;
        [_containerView addSubview:self.banner];
        [self.banner loadAdWithSceneId:nil];
    }
}

#pragma mark - TradPlusADBannerDelegate
- (void)tpBannerAdLoaded:(NSDictionary *)adInfo {
    self.logLabel.text = @"Banner 加载成功";
    NSLog(@"[Demo][Banner] tpBannerAdLoaded adInfo=%@", adInfo ?: @{});
    [self.banner showWithSceneId:nil];
}
- (void)tpBannerAdLoadFailWithError:(NSError *)error {
    self.logLabel.text = [NSString stringWithFormat:@"Banner 加载失败(%ld): %@", (long)error.code, error.localizedDescription];
    NSLog(@"[Demo][Banner] tpBannerAdLoadFailWithError code=%ld desc=%@ userInfo=%@",
          (long)error.code,
          error.localizedDescription ?: @"",
          error.userInfo ?: @{});
}

- (void)tpBannerAdClicked:(nonnull NSDictionary *)adInfo { 
    NSLog(@"[Demo][Banner] tpBannerAdClicked adInfo=%@", adInfo ?: @{});
}

- (void)tpBannerAdImpression:(nonnull NSDictionary *)adInfo { 
    NSLog(@"[Demo][Banner] tpBannerAdImpression adInfo=%@", adInfo ?: @{});
}


- (void)tpBannerAdShow:(nonnull NSDictionary *)adInfo didFailWithError:(nonnull NSError *)error { 
    NSLog(@"[Demo][Banner] tpBannerAdShow didFail code=%ld desc=%@ adInfo=%@ userInfo=%@",
          (long)error.code,
          error.localizedDescription ?: @"",
          adInfo ?: @{},
          error.userInfo ?: @{});
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
//
//}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    
}

- (void)setNeedsFocusUpdate { 
    
}

//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
//
//}

- (void)updateFocusIfNeeded { 
    
}

@end
