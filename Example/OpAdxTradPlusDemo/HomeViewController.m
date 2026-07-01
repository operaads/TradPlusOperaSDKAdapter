//
//  HomeViewController.m
//  OpAdxTradPlusDemo
//
//  参考 ToponDemo 首页与 tradplus-ios-demo-main MsADTableViewController，列出各广告位入口.
//

#import "HomeViewController.h"
#import "SplashVC.h"
#import "BannerVC.h"
#import "InterstitialVC.h"
#import "RewardedVC.h"
#import "NativeVC.h"
#import "InterstitialC2SBidingVC.h"
#import "SplashC2SBidingVC.h"
#import "BannerC2SBidingVC.h"
#import "RewardedC2SBidingVC.h"
#import "NativeC2SBidingVC.h"

static NSString * const kCellId = @"Cell";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *items;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OpAdx TradPlus Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = @[
        @{ @"title": @"开屏广告", @"subtitle": @"Splash" },
        @{ @"title": @"C2S开屏广告", @"subtitle": @"Splash C2S" },
        @{ @"title": @"横幅广告", @"subtitle": @"Banner" },
        @{ @"title": @"C2SBanner广告", @"subtitle": @"Banner C2S" },
        @{ @"title": @"插屏广告", @"subtitle": @"Interstitial" },
        @{ @"title": @"C2S插屏广告", @"subtitle": @"Interstitial" },
        @{ @"title": @"激励视频", @"subtitle": @"Rewarded" },
        @{ @"title": @"C2S激励视频", @"subtitle": @"Rewarded C2S" },
        @{ @"title": @"原生广告", @"subtitle": @"Native" },
        @{ @"title": @"C2S原生广告", @"subtitle": @"Native C2S" },
    ];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    self.tableView.rowHeight = 56;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.items[indexPath.row][@"title"];
    UIViewController *vc = nil;
    if ([title isEqualToString:@"开屏广告"]) {
        vc = [[SplashVC alloc] init];
    } else if ([title isEqualToString:@"C2S开屏广告"]) {
        vc = [[SplashC2SBidingVC alloc] init];
    } else if ([title isEqualToString:@"横幅广告"]) {
        vc = [[BannerVC alloc] init];
    } else if ([title isEqualToString:@"C2SBanner广告"]) {
        vc = [[BannerC2SBidingVC alloc] init];
    } else if ([title isEqualToString:@"插屏广告"]) {
        vc = [[InterstitialVC alloc] init];
    } else if ([title isEqualToString:@"C2S插屏广告"]){
        vc = [[InterstitialC2SBidingVC alloc] init];
    } else if ([title isEqualToString:@"激励视频"]) {
        vc = [[RewardedVC alloc] init];
    } else if ([title isEqualToString:@"C2S激励视频"]) {
        vc = [[RewardedC2SBidingVC alloc] init];
    } else if ([title isEqualToString:@"原生广告"]) {
        vc = [[NativeVC alloc] init];
    } else if ([title isEqualToString:@"C2S原生广告"]) {
        vc = [[NativeC2SBidingVC alloc] init];
    }
    if (vc) {
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
