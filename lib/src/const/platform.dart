import 'package:flutter/foundation.dart';

/// 是否为 Web
const bool isWeb = kIsWeb;

/// 是否为 macOS
bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

/// 是否为 Windows
bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

/// 是否为 Linux
bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;

/// 是否为 Android
bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

/// 是否为 iOS
bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

/// 是否为 Fuchsia
bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

/// 是否为鸿蒙
bool get isHarmonyOS => defaultTargetPlatform.name == 'ohos';

/// 是否为移动端（Android / iOS / 鸿蒙）
bool get isMobile => isAndroid || isIOS || isHarmonyOS;

/// 是否为桌面端（macOS / Windows / Linux）
bool get isDesktop => isMacOS || isWindows || isLinux;

/// 是否为 Release 模式
const bool isRelease = kReleaseMode;

/// 是否为 Profile 模式
const bool isProfile = kProfileMode;

/// 是否为 Debug 模式
const bool isDebug = kDebugMode;
