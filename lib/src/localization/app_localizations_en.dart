// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'UUID Format Tester';

  @override
  String get uuidVersion => 'UUID Version';

  @override
  String get v1Timestamp => 'v1 (timestamp)';

  @override
  String get v4Random => 'v4 (random)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (timestamp sorted)';

  @override
  String get v7UnixTime => 'v7 (Unix time)';

  @override
  String get v8Custom => 'v8 (custom)';

  @override
  String get lowercaseBase32 => 'Lowercase Base32:';

  @override
  String get addUuid => 'Add UUID';

  @override
  String get add10 => 'Add 10';

  @override
  String get clearAll => 'Clear All';

  @override
  String get scrollToTop => 'Scroll to Top';

  @override
  String get noUuidsYet => 'No UUIDs yet. Click \"Add UUID\" to generate one.';

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
}
