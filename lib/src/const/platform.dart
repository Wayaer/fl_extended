import 'package:flutter/foundation.dart';

const bool isWeb = kIsWeb;

bool isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

bool isWindows = defaultTargetPlatform == TargetPlatform.windows;

bool isLinux = defaultTargetPlatform == TargetPlatform.linux;

bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

bool isFuchsia = defaultTargetPlatform == TargetPlatform.fuchsia;

bool isMobile = isAndroid || isIOS;

bool isDesktop = isMacOS || isWindows || isLinux;

const bool isRelease = kReleaseMode;

const bool isProfile = kProfileMode;

const bool isDebug = kDebugMode;
