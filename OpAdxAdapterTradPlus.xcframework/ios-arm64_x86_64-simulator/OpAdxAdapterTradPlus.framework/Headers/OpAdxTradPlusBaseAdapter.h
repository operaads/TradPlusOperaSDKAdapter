#import <TradPlusAds/TradPlusBaseAdapter.h>

NS_ASSUME_NONNULL_BEGIN

@class TradPlusAdWaterfallItem;

@interface OpAdxTradPlusBaseAdapter : TradPlusBaseAdapter

- (void)initializeOpAdxIfNeeded:(NSDictionary *)config completion:(void (^)(BOOL success, NSError * _Nullable error))completion;
- (nullable NSString *)placementIdFromConfig:(NSDictionary *)config;
- (void)applyVideoMuteFromConfig:(NSDictionary *)config waterfallItem:(nullable TradPlusAdWaterfallItem *)item;

@end

NS_ASSUME_NONNULL_END

