// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'UUID 형식 테스터';

  @override
  String get uuidVersion => 'UUID 버전';

  @override
  String get v1Timestamp => 'v1 (타임스탬프)';

  @override
  String get v4Random => 'v4 (랜덤)';

  @override
  String get v5Sha1 => 'v5 (SHA-1)';

  @override
  String get v6TimestampSorted => 'v6 (정렬된 타임스탬프)';

  @override
  String get v7UnixTime => 'v7 (Unix 시간)';

  @override
  String get v8Custom => 'v8 (사용자 정의)';

  @override
  String get lowercaseBase32 => '소문자 Base32:';

  @override
  String get addUuid => 'UUID 추가';

  @override
  String get add10 => '10개 추가';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get scrollToTop => '맨 위로 스크롤';

  @override
  String get noUuidsYet => '아직 UUID가 없습니다. \"UUID 추가\"를 클릭하여 생성하세요.';

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
