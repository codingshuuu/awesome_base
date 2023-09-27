import 'package:awesome_ext/awesome_ext.dart';
import 'package:awesome_ext/utils/event_bus_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'base_config.dart';
import '../event/language_event.dart';

abstract class BaseLanguageUtil {
  //支持的多语言
  List<Language> getLanguages();

  Language? _selectLanguage;

  void setLocalModel(Language model) {
    final List<Language> list = getLanguages();
    if (list.contains(model)) {
      _selectLanguage = model;
    } else {
      _selectLanguage = list[0];
    }
    BaseConfig.lang = getLanguageCode(_selectLanguage);
    SpUtil.putObject(BaseConfig.keyLanguageJson, _selectLanguage!.toJson());
    EventBusUtil.fire(LanguageEvent(model.toLocale()));
    Get.updateLocale(model.toLocale());
  }

  Language getCurrentLanguage([BuildContext? context]) {
    if (null == _selectLanguage) {
      _selectLanguage = SpUtil.getObj(BaseConfig.keyLanguageJson, (Map v) => Language.fromJson(v as Map<String, dynamic>));
      _selectLanguage ??= getLanguages()[0];
    }
    return _selectLanguage!;
  }

  Language initLanguage() {
    final Locale? deviceLocale = Get.deviceLocale;
    final Language? selectLanguage =
        SpUtil.getObj(BaseConfig.keyLanguageJson, (Map v) => Language.fromJson(v as Map<String, dynamic>));
    //首次设置，使用系统的，没有再默认英文
    if (selectLanguage == null) {
      final List<Language> list = getLanguages();

      for (final element in list) {
        if (deviceLocale!.languageCode == element.languageCode ||
            element.languageCode.contains(deviceLocale.languageCode)) {
          setLocalModel(element);
          return element;
        }
      }
      return list[0];
    }
    return selectLanguage;
  }

  String getLanguageCode([Language? model]) {
    model ??= getCurrentLanguage();
    if (model.languageCode == 'zh') {
      return 'zh-cn';
    } else if (model.languageCode == 'tc') {
      return 'zh-tw';
    }
    return model.languageCode;
  }
}
class Language {
  String titleId;
  String languageCode;
  String countryCode;
  int selected;

  Language(this.titleId, this.languageCode, this.countryCode,
      {this.selected = 0});

  bool get isSelected => 1 == selected;

  Language.fromJson(Map<String?, dynamic> json)
      : titleId = json.asString('titleId'),
        languageCode = json.asString('languageCode'),
        countryCode = json.asString('countryCode'),
        selected = json.asInt('selected');

  Map<String, dynamic> toJson() => {
    'titleId': titleId,
    'languageCode': languageCode,
    'countryCode': countryCode,
    'selected': selected,
  };

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }

  @override
  String toString() {
    return 'LanguageModel{titleId: $titleId, languageCode: $languageCode, countryCode: $countryCode, selected: $selected}';
  }

  @override
  int get hashCode => titleId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Language) {
      return other.titleId == titleId;
    }
    return super == other;
  }
}
