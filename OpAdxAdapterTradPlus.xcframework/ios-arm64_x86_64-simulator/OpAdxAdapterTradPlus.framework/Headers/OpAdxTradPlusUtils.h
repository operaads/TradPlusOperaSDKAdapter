#import <Foundation/Foundation.h>
#import <OpAdxSdk/OpAdxSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpAdxTradPlusUtils : NSObject

+ (nullable NSString *)stringValueForKey:(NSString *)key from:(NSDictionary *)dict;
+ (BOOL)boolValueForKey:(NSString *)key from:(NSDictionary *)dict defaultValue:(BOOL)defaultValue;
+ (nullable NSError *)errorFromOpAdxError:(nullable OpAdxAdError *)error;
+ (NSString *)tradPlusSdkVersion;
+ (nullable NSString *)usPrivacyStringFromTradPlus;
+ (nullable NSNumber *)coppaValueFromTradPlus;
+ (double)winnerPriceFromC2SLossInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END

