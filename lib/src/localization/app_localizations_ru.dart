// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'UUID Тестер Форматов';

  @override
  String get uuidVersion => 'Версия UUID';

  @override
  String get v1Timestamp => 'v1 (временная метка)';

  @override
  String get v4Random => 'v4 (случайный)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (сортированная временная метка)';

  @override
  String get v7UnixTime => 'v7 (время Unix)';

  @override
  String get v8Custom => 'v8 (пользовательский)';

  @override
  String get lowercaseBase32 => 'Строчные буквы Base32:';

  @override
  String get addUuid => 'Добавить UUID';

  @override
  String get add10 => 'Добавить 10';

  @override
  String get clearAll => 'Очистить все';

  @override
  String get scrollToTop => 'Прокрутить вверх';

  @override
  String get noUuidsYet =>
      'UUID пока нет. Нажмите \"Добавить UUID\", чтобы сгенерировать один.';

  @override
  String get uuid => 'UUID';

  @override
  String get base32 => 'Base32';

  @override
  String get base36 => 'Base36';

  @override
  String get base48 => 'Base48';

  @override
  String get base52 => 'Base52';

  @override
  String get base58 => 'Base58';

  @override
  String get base62 => 'Base62';

  @override
  String get base64 => 'Base64';

  @override
  String get base85 => 'Base85';

  @override
  String get base45 => 'Base45';

  @override
  String get base91 => 'Base91';

  @override
  String get base92 => 'Base92';

  @override
  String get base100 => 'Base💯';
}
