/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconGen {
  const $AssetsIconGen();

  /// File path: assets/icon/androidlogo.png
  AssetGenImage get androidlogo =>
      const AssetGenImage('assets/icon/androidlogo.png');

  /// File path: assets/icon/androidlogo_padded_512x512.png
  AssetGenImage get androidlogoPadded512x512 =>
      const AssetGenImage('assets/icon/androidlogo_padded_512x512.png');

  /// File path: assets/icon/androidlogo_square_192x192.png
  AssetGenImage get androidlogoSquare192x192 =>
      const AssetGenImage('assets/icon/androidlogo_square_192x192.png');

  /// File path: assets/icon/flexhomelogo.png
  AssetGenImage get flexhomelogo =>
      const AssetGenImage('assets/icon/flexhomelogo.png');

  /// File path: assets/icon/flexicon3.png
  AssetGenImage get flexicon3 =>
      const AssetGenImage('assets/icon/flexicon3.png');

  /// File path: assets/icon/flexlogo.png
  AssetGenImage get flexlogo => const AssetGenImage('assets/icon/flexlogo.png');

  /// File path: assets/icon/flexpayicon.jpeg
  AssetGenImage get flexpayicon =>
      const AssetGenImage('assets/icon/flexpayicon.jpeg');

  /// File path: assets/icon/flexpaylogo.png
  AssetGenImage get flexpaylogo =>
      const AssetGenImage('assets/icon/flexpaylogo.png');

  /// File path: assets/icon/ioslogo.png
  AssetGenImage get ioslogo => const AssetGenImage('assets/icon/ioslogo.png');

  /// File path: assets/icon/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icon/logo.png');

  /// File path: assets/icon/userprofile.png
  AssetGenImage get userprofile =>
      const AssetGenImage('assets/icon/userprofile.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    androidlogo,
    androidlogoPadded512x512,
    androidlogoSquare192x192,
    flexhomelogo,
    flexicon3,
    flexlogo,
    flexpayicon,
    flexpaylogo,
    ioslogo,
    logo,
    userprofile,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/Background.png');

  /// File path: assets/images/Leaderboard1.png
  AssetGenImage get leaderboard1 =>
      const AssetGenImage('assets/images/Leaderboard1.png');

  /// File path: assets/images/appbarbackground.png
  AssetGenImage get appbarbackground =>
      const AssetGenImage('assets/images/appbarbackground.png');

  /// File path: assets/images/chamatype.json
  String get chamatype => 'assets/images/chamatype.json';

  /// Directory path: assets/images/dashboardimages
  $AssetsImagesDashboardimagesGen get dashboardimages =>
      const $AssetsImagesDashboardimagesGen();

  /// File path: assets/images/happyafricanlogin.png
  AssetGenImage get happyafricanlogin =>
      const AssetGenImage('assets/images/happyafricanlogin.png');

  /// File path: assets/images/leaderboard.json
  String get leaderboard => 'assets/images/leaderboard.json';

  /// File path: assets/images/login.webm
  String get login => 'assets/images/login.webm';

  /// File path: assets/images/onboarding.png
  AssetGenImage get onboardingPng =>
      const AssetGenImage('assets/images/onboarding.png');

  /// File path: assets/images/onboarding.webm
  String get onboardingWebm => 'assets/images/onboarding.webm';

  /// File path: assets/images/onboarding2.json
  String get onboarding2 => 'assets/images/onboarding2.json';

  /// File path: assets/images/onboardingSlide1.png
  AssetGenImage get onboardingSlide1 =>
      const AssetGenImage('assets/images/onboardingSlide1.png');

  /// File path: assets/images/otpver.json
  String get otpver => 'assets/images/otpver.json';

  /// File path: assets/images/otpverification.webm
  String get otpverification => 'assets/images/otpverification.webm';

  /// File path: assets/images/success.json
  String get success => 'assets/images/success.json';

  /// List of all assets
  List<dynamic> get values => [
    background,
    leaderboard1,
    appbarbackground,
    chamatype,
    happyafricanlogin,
    leaderboard,
    login,
    onboardingPng,
    onboardingWebm,
    onboarding2,
    onboardingSlide1,
    otpver,
    otpverification,
    success,
  ];
}

class $AssetsImagesDashboardimagesGen {
  const $AssetsImagesDashboardimagesGen();

  /// File path: assets/images/dashboardimages/Car-and-General.png
  AssetGenImage get carAndGeneral =>
      const AssetGenImage('assets/images/dashboardimages/Car-and-General.png');

  /// File path: assets/images/dashboardimages/Hotpoint.png
  AssetGenImage get hotpoint =>
      const AssetGenImage('assets/images/dashboardimages/Hotpoint.png');

  /// File path: assets/images/dashboardimages/Moko.png
  AssetGenImage get moko =>
      const AssetGenImage('assets/images/dashboardimages/Moko.png');

  /// File path: assets/images/dashboardimages/Naivas.png
  AssetGenImage get naivas =>
      const AssetGenImage('assets/images/dashboardimages/Naivas.png');

  /// File path: assets/images/dashboardimages/Quickmart.png
  AssetGenImage get quickmart =>
      const AssetGenImage('assets/images/dashboardimages/Quickmart.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    carAndGeneral,
    hotpoint,
    moko,
    naivas,
    quickmart,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
