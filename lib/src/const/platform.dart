import 'package:flutter/foundation.dart';

/// is web
const bool isWeb = kIsWeb;

/// is macos
bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

/// is windows
bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

/// is linux
bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;

/// is android
bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

/// is ios
bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

/// is fuchsia
bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

/// is harmony OS
bool get isHarmonyOS => defaultTargetPlatform.name == 'ohos';

/// is mobile
bool get isMobile => isAndroid || isIOS || isHarmonyOS;

/// is desktop
bool get isDesktop => isMacOS || isWindows || isLinux;

const bool isRelease = kReleaseMode;

const bool isProfile = kProfileMode;

const bool isDebug = kDebugMode;
