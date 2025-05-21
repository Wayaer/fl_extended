import 'package:flutter/material.dart';

extension ExtensionThemeData on ThemeData {
  ThemeData marge([ThemeData? themeData]) => ThemeData.raw(
    adaptationMap: themeData?.adaptationMap ?? adaptationMap,
    applyElevationOverlayColor:
        themeData?.applyElevationOverlayColor ?? applyElevationOverlayColor,
    cupertinoOverrideTheme:
        themeData?.cupertinoOverrideTheme ?? cupertinoOverrideTheme,
    extensions: themeData?.extensions ?? extensions,
    inputDecorationTheme:
        themeData?.inputDecorationTheme ?? inputDecorationTheme,
    materialTapTargetSize:
        themeData?.materialTapTargetSize ?? materialTapTargetSize,
    pageTransitionsTheme:
        themeData?.pageTransitionsTheme ?? pageTransitionsTheme,
    platform: themeData?.platform ?? platform,
    scrollbarTheme: themeData?.scrollbarTheme ?? scrollbarTheme,
    splashFactory: themeData?.splashFactory ?? splashFactory,
    useMaterial3: themeData?.useMaterial3 ?? useMaterial3,
    visualDensity: themeData?.visualDensity ?? visualDensity,
    canvasColor: themeData?.canvasColor ?? canvasColor,
    cardColor: themeData?.cardColor ?? cardColor,
    colorScheme: themeData?.colorScheme ?? colorScheme,
    dialogBackgroundColor:
        themeData?.dialogTheme.backgroundColor ?? dialogBackgroundColor,
    disabledColor: themeData?.disabledColor ?? disabledColor,
    dividerColor: themeData?.dividerColor ?? dividerColor,
    focusColor: themeData?.focusColor ?? focusColor,
    highlightColor: themeData?.highlightColor ?? highlightColor,
    hintColor: themeData?.hintColor ?? hintColor,
    hoverColor: themeData?.hoverColor ?? hoverColor,
    indicatorColor: themeData?.tabBarTheme.indicatorColor ?? indicatorColor,
    primaryColor: themeData?.primaryColor ?? primaryColor,
    primaryColorDark: themeData?.primaryColorDark ?? primaryColorDark,
    primaryColorLight: themeData?.primaryColorLight ?? primaryColorLight,
    scaffoldBackgroundColor:
        themeData?.scaffoldBackgroundColor ?? scaffoldBackgroundColor,
    secondaryHeaderColor:
        themeData?.secondaryHeaderColor ?? secondaryHeaderColor,
    shadowColor: themeData?.shadowColor ?? shadowColor,
    splashColor: themeData?.splashColor ?? splashColor,
    unselectedWidgetColor:
        themeData?.unselectedWidgetColor ?? unselectedWidgetColor,
    // TYPOGRAPHY & ICONOGRAPHY
    iconTheme: themeData?.iconTheme ?? iconTheme,
    primaryTextTheme: themeData?.primaryTextTheme ?? primaryTextTheme,
    textTheme: themeData?.textTheme ?? textTheme,
    typography: themeData?.typography ?? typography,
    primaryIconTheme: themeData?.primaryIconTheme ?? primaryIconTheme,
    // COMPONENT THEMES
    actionIconTheme: themeData?.actionIconTheme ?? actionIconTheme,
    appBarTheme: themeData?.appBarTheme ?? appBarTheme,
    badgeTheme: themeData?.badgeTheme ?? badgeTheme,
    bannerTheme: themeData?.bannerTheme ?? bannerTheme,
    bottomAppBarTheme: themeData?.bottomAppBarTheme ?? bottomAppBarTheme,
    bottomNavigationBarTheme:
        themeData?.bottomNavigationBarTheme ?? bottomNavigationBarTheme,
    bottomSheetTheme: themeData?.bottomSheetTheme ?? bottomSheetTheme,
    buttonTheme: themeData?.buttonTheme ?? buttonTheme,
    cardTheme: themeData?.cardTheme ?? cardTheme,
    checkboxTheme: themeData?.checkboxTheme ?? checkboxTheme,
    chipTheme: themeData?.chipTheme ?? chipTheme,
    dataTableTheme: themeData?.dataTableTheme ?? dataTableTheme,
    datePickerTheme: themeData?.datePickerTheme ?? datePickerTheme,
    dialogTheme: themeData?.dialogTheme ?? dialogTheme,
    dividerTheme: themeData?.dividerTheme ?? dividerTheme,
    drawerTheme: themeData?.drawerTheme ?? drawerTheme,
    dropdownMenuTheme: themeData?.dropdownMenuTheme ?? dropdownMenuTheme,
    elevatedButtonTheme: themeData?.elevatedButtonTheme ?? elevatedButtonTheme,
    expansionTileTheme: themeData?.expansionTileTheme ?? expansionTileTheme,
    filledButtonTheme: themeData?.filledButtonTheme ?? filledButtonTheme,
    floatingActionButtonTheme:
        themeData?.floatingActionButtonTheme ?? floatingActionButtonTheme,
    iconButtonTheme: themeData?.iconButtonTheme ?? iconButtonTheme,
    listTileTheme: themeData?.listTileTheme ?? listTileTheme,
    menuBarTheme: themeData?.menuBarTheme ?? menuBarTheme,
    menuButtonTheme: themeData?.menuButtonTheme ?? menuButtonTheme,
    menuTheme: themeData?.menuTheme ?? menuTheme,
    navigationBarTheme: themeData?.navigationBarTheme ?? navigationBarTheme,
    navigationDrawerTheme:
        themeData?.navigationDrawerTheme ?? navigationDrawerTheme,
    navigationRailTheme: themeData?.navigationRailTheme ?? navigationRailTheme,
    outlinedButtonTheme: themeData?.outlinedButtonTheme ?? outlinedButtonTheme,
    popupMenuTheme: themeData?.popupMenuTheme ?? popupMenuTheme,
    progressIndicatorTheme:
        themeData?.progressIndicatorTheme ?? progressIndicatorTheme,
    radioTheme: themeData?.radioTheme ?? radioTheme,
    searchBarTheme: themeData?.searchBarTheme ?? searchBarTheme,
    searchViewTheme: themeData?.searchViewTheme ?? searchViewTheme,
    segmentedButtonTheme:
        themeData?.segmentedButtonTheme ?? segmentedButtonTheme,
    sliderTheme: themeData?.sliderTheme ?? sliderTheme,
    snackBarTheme: themeData?.snackBarTheme ?? snackBarTheme,
    switchTheme: themeData?.switchTheme ?? switchTheme,
    tabBarTheme: themeData?.tabBarTheme ?? tabBarTheme,
    textButtonTheme: themeData?.textButtonTheme ?? textButtonTheme,
    textSelectionTheme: themeData?.textSelectionTheme ?? textSelectionTheme,
    timePickerTheme: themeData?.timePickerTheme ?? timePickerTheme,
    toggleButtonsTheme: themeData?.toggleButtonsTheme ?? toggleButtonsTheme,
    tooltipTheme: themeData?.tooltipTheme ?? tooltipTheme,
  );
}
