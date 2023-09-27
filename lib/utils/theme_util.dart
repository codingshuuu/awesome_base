import 'package:awesome_ext/awesome_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_config.dart';

class ThemeUtil {
  static bool currentIsDark = false;

  static ThemeData copyTheme(
    Color themeColor, {
    Color? appBarColor,
    bool centerTitle = true,
    bool isDarkMode = false,
  }) {
    return (isDarkMode ? ThemeData.dark() : ThemeData.light()).copyWith(
      primaryColor: themeColor,
      //默认的主题色
      // primaryColorBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(themeColor)),
      ),
      colorScheme: isDarkMode
          ? ColorScheme.dark(
              secondary: themeColor,
              primary: themeColor,
              onSecondary: themeColor,
            )
          : ColorScheme.light(
              secondary: themeColor,
              primary: themeColor,
              onSecondary: themeColor,
            ),
      // toggleableActiveColor: themeColor,
      appBarTheme: AppBarTheme(centerTitle: centerTitle, backgroundColor: appBarColor),
    );
  }

  static void initThemeMode() {
    ThemeMode themeMode = getThemeMode();
    if (themeMode == ThemeMode.system) {
      themeMode = Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
    currentIsDark = themeMode == ThemeMode.dark;
    Get.changeThemeMode(themeMode);
  }

  static void setThemeMode(ThemeMode themeMode) {
    SpUtil.putString(BaseConfig.theme, themeMode.name);
    if (themeMode == ThemeMode.system) {
      themeMode = Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
    currentIsDark = themeMode == ThemeMode.dark;
    Get.changeThemeMode(themeMode);
    debugPrint('setThemeMode click setThemeMode=$themeMode,currentIsDark=$currentIsDark');
    Get.forceAppUpdate();
  }

  static ThemeMode getThemeMode() {
    final String theme = SpUtil.getString(BaseConfig.theme).nullSafe;
    ThemeMode themeMode;
    switch (theme) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    return themeMode;
  }

  static int getThemeIndex() {
    final String theme = getThemeMode().name;
    int index = 0;
    switch (theme) {
      case 'dark':
        index = 1;
        break;
      case 'light':
        index = 2;
        break;
      default:
        break;
    }
    return index;
  }

  static bool isDark(BuildContext context) {
    return currentIsDark; //Theme.of(context).brightness == Brightness.dark;
  }

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }
}

extension ThemeExtension on BuildContext {
  bool get isDark => ThemeUtil.isDark(this);

  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get dialogBackgroundColor => Theme.of(this).canvasColor;
}
