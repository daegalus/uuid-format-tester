// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'UUID Format Tester';

  @override
  String get uuidVersion => 'UUID Version';

  @override
  String get v1Timestamp => 'v1 (tidsstempel)';

  @override
  String get v4Random => 'v4 (tilfældig)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (tidsstempel sorteret)';

  @override
  String get v7UnixTime => 'v7 (Unix tid)';

  @override
  String get v8Custom => 'v8 (brugerdefineret)';

  @override
  String get lowercaseBase32 => 'Små bogstaver Base32:';

  @override
  String get addUuid => 'Tilføj UUID';

  @override
  String get add10 => 'Tilføj 10';

  @override
  String get clearAll => 'Ryd alle';

  @override
  String get scrollToTop => 'Rul til toppen';

  @override
  String get noUuidsYet =>
      'Ingen UUID\'er endnu. Klik på \"Tilføj UUID\" for at generere en.';

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
