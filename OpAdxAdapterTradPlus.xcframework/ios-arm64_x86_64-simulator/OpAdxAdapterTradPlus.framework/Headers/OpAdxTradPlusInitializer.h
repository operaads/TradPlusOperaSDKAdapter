#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpAdxTradPlusInitializer : NSObject

+ (instancetype)shared;
- (void)initializeWithConfig:(NSDictionary *)config completion:(void (^)(BOOL success, NSError * _Nullable error))completion;
- (void)performWhenInitializedWithConfig:(NSDictionary *)config completion:(void (^)(BOOL success, NSError * _Nullable error))completion;

@property (nonatomic, copy, nullable) void (^loadFinishAct)(void);
@property (nonatomic, copy, nullable) void (^loadFailAct)(NSError *error);
@property (nonatomic, copy, nullable) void (^configErrorAct)(NSError *error);
@property (nonatomic, copy, nullable) void (^extraLoadCallback)(void);
@property (nonatomic, strong, nullable) id waterfallItem;

// TradPlus 当前会调用这些 setter；这里只保留签名兼容，不持有/不执行传入回调。
- (void)setLoadEnd:(id)loadEnd;     // 对应 TradPlus 的 setLoadEnd:
- (void)setDidStartLoad:(id)callback;
- (void)setWaitingPoolLoadFinishAct:(id)callback;
- (void)setWaitingPoolLoadFailAct:(id)callback;
- (void)loadAdWithWaterfallItem:(id)waterfallItem;
- (void)loadEnd;
@end

NS_ASSUME_NONNULL_END

