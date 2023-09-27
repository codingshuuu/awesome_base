import 'package:awesome_base/utils/theme_util.dart';
import 'package:awesome_base/utils/global.dart';
import 'package:awesome_ext/awesome_ext.dart';
import 'package:awesome_ext/mixin/route/my_route_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../utils/base_config.dart';

///整个主题可由业务项目 构造回调
typedef ThemeBuilder = ThemeData Function(Color themeColor);

class App extends StatefulWidget {
  final Color? defaultThemeColor;
  final String initialRoute;
  final List<GetPage> getPages;
  final Locale locale;
  final Translations translations;
  final ThemeBuilder? themeBuilder;
  final List<SingleChildWidget> providers;
  final Locale? fallbackLocale;
  ///route监听
  final List<NavigatorObserver>? navigatorObservers;

  const App({
    this.defaultThemeColor,
    required this.initialRoute,
    required this.getPages,
    required this.locale,
    required this.translations,
    required this.providers,
    this.themeBuilder,
    this.fallbackLocale,
    this.navigatorObservers,
    Key? key,
  })  : assert(defaultThemeColor != null || themeBuilder != null),
        super(key: key);

  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  late Color _themeColor;

  @override
  void initState() {
    super.initState();
    initListener();
  }

  void initListener() {
    final colorValue = SpUtil.getInt(BaseConfig.keyTheme)!;
    if (colorValue != 0) {
      _themeColor = Color(colorValue);
    } else {
      _themeColor = widget.defaultThemeColor ?? Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: widget.providers,
      child: GetMaterialApp(
        navigatorObservers: widget.navigatorObservers ?? [myRouteObserver],
        debugShowCheckedModeBanner: false,
        enableLog: !kReleaseMode,
        // logWriterCallback: Logger.write,
        initialRoute: widget.initialRoute,
        getPages: widget.getPages,
        defaultTransition: Transition.cupertino,
        locale: widget.locale,
        themeMode: ThemeMode.dark,
        theme: widget.themeBuilder?.call(_themeColor) ?? ThemeUtil.copyTheme(_themeColor, isDarkMode: false),
        translations: widget.translations,
        fallbackLocale: widget.fallbackLocale,
        builder: (context, child) {
          var isPad = !kIsWeb && (context.isTablet || GetPlatform.isDesktop);
          if (isPad) {
            Global.setTable(1024, 768.0);
          } else {
            final size = MediaQuery.of(context).size;
            setDesignWHD(size.width, size.height);
          }
          final innerChild = GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          );
          if (kIsWeb && MediaQuery.of(context).size.width > 700) {
            return Container(
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: innerChild,
                ),
              ),
            );
          }
          return innerChild;
        },
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
