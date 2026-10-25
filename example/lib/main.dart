import 'package:example/src/demo/demo_widgets.dart';
import 'package:example/src/home.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

void main() {
  FlLogcat().runZone(() {
    WidgetsFlutterBinding.ensureInitialized();
    final FlExtended fl = FlExtended();
    fl.pushStyle = RoutePushStyle.material;

    /// 全局 Toast
    fl.toastOptions = const ToastOptions.extended(
      animationStyle: FlAnimationStyle.verticalHunting,
      animationDuration: Duration(milliseconds: 260),
      duration: Duration(milliseconds: 1600),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    /// 全局 Loading
    fl.loadingOptions = const LoadingOptions(
      gaussian: 2,
      backgroundColor: Colors.black26,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      constraints: BoxConstraints(minWidth: 120),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );

    /// 全局底部弹层 / 对话框
    fl.modalBottomSheetOptions = const ModalBottomSheetOptions(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
    fl.generalDialogOptions = const GeneralDialogOptions();

    fl.logCrossLine = true;

    runApp(const DemoApp());
  });
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: demoThemeMode,
      builder: (BuildContext context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: FlExtended().navigatorKey,
          scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
          title: 'fl_extended Demo',
          theme: _buildDemoTheme(Brightness.light),
          darkTheme: _buildDemoTheme(Brightness.dark),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

ThemeData _buildDemoTheme(Brightness brightness) {
  final ColorScheme colors = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4E6BFF),
    brightness: brightness,
  );
  final ThemeData base = ThemeData(useMaterial3: true, colorScheme: colors);
  return base.copyWith(
    scaffoldBackgroundColor: colors.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: base.textTheme.titleMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    dividerTheme: DividerThemeData(color: colors.outlineVariant.withValues(alpha: 0.6), space: 1, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.inverseSurface,
      contentTextStyle: TextStyle(color: colors.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: 12.borderRadiusAll),
    ),
  );
}
