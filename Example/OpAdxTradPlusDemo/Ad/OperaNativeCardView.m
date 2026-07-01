//
//  OperaNativeCardView.m
//  OpAdxTradPlusDemo
//

#import "OperaNativeCardView.h"

@interface OperaNativeCardView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UILabel *ctaLabel;
@property (nonatomic, strong) UIImageView *adChoiceImageView;
@end

@implementation OperaNativeCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 背景为浅灰色，整体卡片圆角
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;

    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.layer.cornerRadius = 4.0;
    _iconImageView.layer.masksToBounds = YES;
    [self addSubview:_iconImageView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];

    _descLabel = [[UILabel alloc] init];
    _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.numberOfLines = 2;
    _descLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_descLabel];

    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.userInteractionEnabled = YES;
    [self addSubview:_mainImageView];

    _ctaLabel = [[UILabel alloc] init];
    _ctaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _ctaLabel.font = [UIFont boldSystemFontOfSize:13];
    _ctaLabel.textColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [self addSubview:_ctaLabel];

    _adChoiceImageView = [[UIImageView alloc] init];
    _adChoiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _adChoiceImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_adChoiceImageView];

    // 纯代码 Auto Layout
    CGFloat margin = 16.0;

    [NSLayoutConstraint activateConstraints:@[
        // Icon（左上，稍大一些）
        [_iconImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:margin],
        [_iconImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:margin],
        [_iconImageView.widthAnchor constraintEqualToConstant:32],
        [_iconImageView.heightAnchor constraintEqualToConstant:32],

        // AdChoice 在右上角
        [_adChoiceImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-margin],
        [_adChoiceImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:margin],
        [_adChoiceImageView.widthAnchor constraintEqualToConstant:16],
        [_adChoiceImageView.heightAnchor constraintEqualToConstant:16],

        // Title：与 icon 垂直居中对齐
        [_titleLabel.leadingAnchor constraintEqualToAnchor:_iconImageView.trailingAnchor constant:8],
        [_titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:_adChoiceImageView.leadingAnchor constant:-8],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:_iconImageView.centerYAnchor],

        // 主图：在标题下方
        [_mainImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_mainImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_mainImageView.topAnchor constraintEqualToAnchor:_iconImageView.bottomAnchor constant:8],
        [_mainImageView.heightAnchor constraintEqualToConstant:160],

        // 描述：位于大图下方，居左
        [_descLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:margin],
        [_descLabel.trailingAnchor constraintLessThanOrEqualToAnchor:_ctaLabel.leadingAnchor constant:-8],
        [_descLabel.topAnchor constraintEqualToAnchor:_mainImageView.bottomAnchor constant:8],

        // CTA 文案：与描述行在垂直方向居中对齐
        [_ctaLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-margin],
        [_ctaLabel.centerYAnchor constraintEqualToAnchor:_descLabel.centerYAnchor],
        [_ctaLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-margin],
        [_ctaLabel.heightAnchor constraintGreaterThanOrEqualToConstant:20],
        [_ctaLabel.widthAnchor constraintGreaterThanOrEqualToConstant:60]
    ]];
}

#pragma mark - TradPlusNativeAdRendering

- (UILabel *)nativeTitleTextLabel {
    return self.titleLabel;
}

- (UILabel *)nativeMainTextLabel {
    return self.descLabel;
}

- (UIImageView *)nativeIconImageView {
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView {
    return self.mainImageView;
}

- (UILabel *)nativeCallToActionTextLabel {
    return self.ctaLabel;
}

- (UIView *)nativeCallToActionView {
    return self.ctaLabel;
}

- (UIImageView *)nativePrivacyInformationIconImageView {
    return self.adChoiceImageView;
}

- (NSArray *)clickViewArray {
    // 主图和 CTA 文案都可点击，行为与 Learn More 一致（跳转落地页）
    return @[self.mainImageView, self.ctaLabel];
}

@end

