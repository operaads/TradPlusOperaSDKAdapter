Pod::Spec.new do |spec|
  # ――― 基本信息 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "TradPlusOperaSDKAdapter"
  spec.version      = "2.11.2.1"
  spec.summary      = "Opera Ads Custom Adapter for TradPlus Mediation Platform."
  spec.description  = <<-DESC
    TradPlusOperaSDKAdapter is a custom mediation adapter that enables the integration of
    Opera Advertising SDK (OpAdxSdk) with the TradPlus mediation platform.

    Supported Ad Formats:
    - Banner Ads (Standard, MREC)
    - Interstitial Ads
    - Rewarded Ads
    - Native Ads

    This adapter bridges Opera Ads SDK callbacks to TradPlus mediation callbacks,
    enabling seamless ad serving through the TradPlus platform.
  DESC

  spec.homepage     = "https://github.com/operaads/TradPlusOperaSDKAdapter"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Opera Ads" => "chenl@opera.com" }

  # ――― 平台设置 ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.0"

  # ――― 源码位置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = {
    :git => "https://github.com/operaads/TradPlusOperaSDKAdapter.git",
    :tag => "#{spec.version}"
  }

  # ――― 文件与依赖配置 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # 制作静态包的关键设置
  spec.static_framework = true

  spec.vendored_frameworks = "OpAdxAdapterTradPlus.xcframework"

  # --- 依赖项 ---
  # TradPlus SDK
  spec.dependency 'TradPlusAdSDK', '>= 15.1.1'

  # Opera Ads SDK - 使用CocoaPods发布的版本
  spec.dependency 'OpAdxSdk', '2.11.2'

  # ――― 元数据 ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

end
