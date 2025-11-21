import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_da.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('da'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'UUID Format Tester'**
  String get appTitle;

  /// Label for UUID version selector
  ///
  /// In en, this message translates to:
  /// **'UUID Version'**
  String get uuidVersion;

  /// UUID v1 timestamp-based
  ///
  /// In en, this message translates to:
  /// **'v1 (timestamp)'**
  String get v1Timestamp;

  /// UUID v4 random
  ///
  /// In en, this message translates to:
  /// **'v4 (random)'**
  String get v4Random;

  /// UUID v5 SHA-1 hash
  ///
  /// In en, this message translates to:
  /// **'v5 (SHA-1)'**
  String get v5Sha1;

  /// UUID v6 timestamp sorted
  ///
  /// In en, this message translates to:
  /// **'v6 (timestamp sorted)'**
  String get v6TimestampSorted;

  /// UUID v7 Unix timestamp
  ///
  /// In en, this message translates to:
  /// **'v7 (Unix time)'**
  String get v7UnixTime;

  /// UUID v8 custom
  ///
  /// In en, this message translates to:
  /// **'v8 (custom)'**
  String get v8Custom;

  /// Label for lowercase Base32 toggle
  ///
  /// In en, this message translates to:
  /// **'Lowercase Base32:'**
  String get lowercaseBase32;

  /// Button to add a single UUID
  ///
  /// In en, this message translates to:
  /// **'Add UUID'**
  String get addUuid;

  /// Button to add 10 UUIDs
  ///
  /// In en, this message translates to:
  /// **'Add 10'**
  String get add10;

  /// Button to clear all UUIDs
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Button to scroll to top of list
  ///
  /// In en, this message translates to:
  /// **'Scroll to Top'**
  String get scrollToTop;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No UUIDs yet. Click \"Add UUID\" to generate one.'**
  String get noUuidsYet;

  /// UUID column header
  ///
  /// In en, this message translates to:
  /// **'UUID'**
  String get uuid;

  /// Base32 column header
  ///
  /// In en, this message translates to:
  /// **'Base32'**
  String get base32;

  /// Base36 column header
  ///
  /// In en, this message translates to:
  /// **'Base36'**
  String get base36;

  /// Base48 column header
  ///
  /// In en, this message translates to:
  /// **'Base48'**
  String get base48;

  /// Base52 column header
  ///
  /// In en, this message translates to:
  /// **'Base52'**
  String get base52;

  /// Base58 column header
  ///
  /// In en, this message translates to:
  /// **'Base58'**
  String get base58;

  /// Base62 column header
  ///
  /// In en, this message translates to:
  /// **'Base62'**
  String get base62;

  /// Base64 column header
  ///
  /// In en, this message translates to:
  /// **'Base64'**
  String get base64;

  /// Base85 column header
  ///
  /// In en, this message translates to:
  /// **'Base85'**
  String get base85;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bg',
        'da',
        'en',
        'ja',
        'ko',
        'ru'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'da':
      return AppLocalizationsDa();
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
