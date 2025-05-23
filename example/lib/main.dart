import 'package:example/src/module/animation_page.dart';
import 'package:example/src/module/builder_page.dart';
import 'package:example/src/module/button_page.dart';
import 'package:example/src/module/progress_indicator_page.dart';
import 'package:example/src/module/state_components_page.dart';
import 'package:example/src/module/text_page.dart';
import 'package:example/src/module/overlay_page.dart';
import 'package:example/src/module/popup_page.dart';
import 'package:example/src/module/universal_page.dart';
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:example/src/scaffold.dart';
import 'package:example/src/theme.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  FlLogcat().runZone(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlExtended flExtended = FlExtended();

    flExtended.pushStyle = RoutePushStyle.material;

    /// 设置全局Toast配置
    flExtended.toastOptions = ToastOptions.extended(
      animationStyle: FlAnimationStyle.verticalHunting,
      textStyle: const TextStyle(color: Colors.white),
      onModalTap: () {
        log('onModalTap');
      },
      onToastTap: () {
        log('onToastTap');
      },
      foregroundColor: Colors.grey,
      backgroundColor: Colors.red.withValues(alpha: 0.3),
      constraints: const BoxConstraints(maxWidth: 250),
      color: Colors.amber,
      builder: (BuildContext context, ToastContent content) {
        return Universal(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (content.iconStyle != null)
              Icon(content.iconStyle!.icon, color: content.color),
            Text(
              content.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: content.color),
            ),
          ],
        );
      },
    );

    /// 设置全局BottomSheet配置
    flExtended.bottomSheetOptions = const BottomSheetOptions(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
    flExtended.dialogOptions = const DialogOptions(
      fromStyle: PopupFromStyle.fromTop,
    );

    flExtended.logCrossLine = true;

    /// 设置全局Loading配置
    flExtended.loadingOptions = LoadingOptions(
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      foregroundColor: Colors.yellow,
      elevation: 2,
      padding: const EdgeInsets.all(10),
      builder: (_, ProgressIndicatorOptions? progressIndicator) {
        if (progressIndicator != null) {
          return FlProgressIndicator(progressIndicator);
        }
        return const Padding(
          padding: EdgeInsets.all(10),
          child: BText('全局设置loading', fontSize: 20),
        );
      },
      onLoadingTap: () {
        log('onLoadingTap');
        hideLoading();
      },
      constraints: const BoxConstraints(maxWidth: 250),
      borderRadius: BorderRadius.circular(10),
      onModalTap: () {
        log('onModalTap');
        hideLoading();
      },
    );
    10000.generate((int index) {
      FlLogcat().insertLog(
        LogContent(
          type: LogType.other,
          dateTime: DateTime.now(),
          line: 'insertLog  $index',
        ),
      );
    });

    runApp(
      DevicePreview(
        enabled: isDesktop || isWeb,
        defaultDevice: Devices.ios.iPhone13Mini,
        builder: (context) => const _MaterialApp(),
      ),
    );
  }, enable: true);
}

class MaterialAppRouter extends StatelessWidget {
  MaterialAppRouter({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: FlExtended().navigatorKey,
    routes: <RouteBase>[],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: FlExtended().navigatorKey,
      scaffoldMessengerKey: FlExtended().scaffoldMessengerKey,
      locale: DevicePreview.locale(context),
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      title: 'Fl Extended',
      home: ExtendedScaffold(
        enableDoubleClickExit: true,
        appBar: AppBarText('Fl Extended example'),
        child: _Home(),
      ),
      builder: DevicePreview.appBuilder,
    );
  }
}

class _Home extends StatefulWidget {
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  @override
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      FlLogcat().isRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Universal(
      padding: const EdgeInsets.all(10),
      isWrap: true,
      isScroll: true,
      wrapAlignment: WrapAlignment.center,
      direction: Axis.horizontal,
      scrollDirection: Axis.vertical,
      children: [
        ElevatedText('Text', onTap: () => push(const TextPage())),
        ElevatedText('Button', onTap: () => push(const ButtonPage())),
        ElevatedText(
          'State Components',
          onTap: () => push(const StateComponentsPage()),
        ),
        ElevatedText('FlAnimation', onTap: () => push(const FlAnimationPage())),
        ElevatedText('Popup', onTap: () => push(const PopupPage())),
        ElevatedText('Overlay', onTap: () => push(const OverlayPage())),
        ElevatedText('Universal', onTap: () => push(const UniversalPage())),
        ElevatedText(
          'FlProgressIndicator',
          onTap: () => push(const ProgressIndicatorPage()),
        ),
        ElevatedText(
          'ExtendedBuilder',
          onTap: () => push(const ExtendedBuilderPage()),
        ),
      ],
    );
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {super.key})
    : super(
        elevation: 0,
        title: BText(text, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
      );
}

class ElevatedText extends StatelessWidget {
  const ElevatedText(this.text, {this.onTap, super.key});

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Universal(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      unifiedButtonCategory: UnifiedButtonCategory.elevated,
      onTap: onTap,
      child: BText(text, textAlign: TextAlign.center),
    );
  }
}

class Partition extends StatelessWidget {
  const Partition(this.title, {super.key, this.onTap, this.marginTop = 20});

  final String title;
  final GestureTapCallback? onTap;
  final double marginTop;

  @override
  Widget build(BuildContext context) => Universal(
    onTap: onTap,
    width: double.infinity,
    color: Colors.grey.withValues(alpha: 0.2),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10),
    margin: EdgeInsets.only(top: marginTop, bottom: 20),
    child: BText(
      title,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
    ),
  );
}

const List<Color> colorList = <Color>[...Colors.accents, ...Colors.primaries];

List<BoxShadow> getBoxShadow({
  int num = 1,
  Color color = Colors.black12,
  double? radius,
  BlurStyle blurStyle = BlurStyle.normal,
  double blurRadius = 0.05,
  double spreadRadius = 0.05,
  Offset? offset,
}) => num.generate(
  (index) => BoxShadow(
    color: color,
    blurStyle: blurStyle,
    blurRadius: radius ?? blurRadius,
    spreadRadius: radius ?? spreadRadius,
    offset: offset ?? const Offset(0, 0),
  ),
);
