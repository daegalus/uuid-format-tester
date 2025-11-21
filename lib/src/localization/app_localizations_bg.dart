// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'UUID Формат Тестер';

  @override
  String get uuidVersion => 'UUID Версия';

  @override
  String get v1Timestamp => 'v1 (времеви печат)';

  @override
  String get v4Random => 'v4 (случаен)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (сортиран времеви печат)';

  @override
  String get v7UnixTime => 'v7 (Unix време)';

  @override
  String get v8Custom => 'v8 (персонализиран)';

  @override
  String get lowercaseBase32 => 'Малки букви Base32:';

  @override
  String get addUuid => 'Добави UUID';

  @override
  String get add10 => 'Добави 10';

  @override
  String get clearAll => 'Изчисти всички';

  @override
  String get scrollToTop => 'Превърти нагоре';

  @override
  String get noUuidsYet =>
      'Все още няма UUID. Кликнете \"Добави UUID\", за да генерирате един.';

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
