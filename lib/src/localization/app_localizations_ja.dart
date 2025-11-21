// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'UUID フォーマットテスター';

  @override
  String get uuidVersion => 'UUID バージョン';

  @override
  String get v1Timestamp => 'v1 (タイムスタンプ)';

  @override
  String get v4Random => 'v4 (ランダム)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (ソート済みタイムスタンプ)';

  @override
  String get v7UnixTime => 'v7 (Unix時刻)';

  @override
  String get v8Custom => 'v8 (カスタム)';

  @override
  String get lowercaseBase32 => '小文字Base32:';

  @override
  String get addUuid => 'UUIDを追加';

  @override
  String get add10 => '10個追加';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get scrollToTop => '先頭にスクロール';

  @override
  String get noUuidsYet => 'まだUUIDがありません。「UUIDを追加」をクリックして生成してください。';

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
  String get base100 => 'Base100';
}
