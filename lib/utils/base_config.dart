import 'package:flutter/foundation.dart';

class BaseConfig {
  static bool debug = !kReleaseMode;
  static const String keyTheme = 'key_theme';
  static const String theme = 'AppTheme';
  static const String keyDebugHost = 'key_debug_host';
  static const String keyDebugHostSwitch = 'key_debug_host_switch';
  static const String host = 'host';
  static const String isEncrypt = 'is_encrypt';

  /// 当前应用选中的 语言model
  static const String keyLanguageJson = 'keyLanguage';

  /// 当前应用选中的语言
  static String lang = '';
}
