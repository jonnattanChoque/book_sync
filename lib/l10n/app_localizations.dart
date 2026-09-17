import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('es'),
  ];

  /// Greeting title on the main dashboard
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get welcomeTitle;

  /// Subtitle greeting on the main dashboard
  ///
  /// In en, this message translates to:
  /// **'Stories reader'**
  String get welcomeMessage;

  /// Default user display name
  ///
  /// In en, this message translates to:
  /// **'Story Reader'**
  String get userName;

  /// General action or button text to add a book
  ///
  /// In en, this message translates to:
  /// **'Add book'**
  String get addBook;

  /// Section header for the book currently being read
  ///
  /// In en, this message translates to:
  /// **'Currently reading'**
  String get currentlyReading;

  /// Reading progress percentage
  ///
  /// In en, this message translates to:
  /// **'{percentage}% completed'**
  String progressLabel(int percentage);

  /// Modal/Screen header for adding a book
  ///
  /// In en, this message translates to:
  /// **'Add a book to your nightstand'**
  String get createBookTitle;

  /// Title shown when the library is empty
  ///
  /// In en, this message translates to:
  /// **'Your nightstand is empty'**
  String get noBooksTitle;

  /// Motivational message for an empty library
  ///
  /// In en, this message translates to:
  /// **'What story will we start today?'**
  String get noBooksSubtitle;

  /// Option to add a book by online search
  ///
  /// In en, this message translates to:
  /// **'Add by search'**
  String get addBySearch;

  /// Option to add a book by scanning its ISBN barcode
  ///
  /// In en, this message translates to:
  /// **'Add by scan (ISBN)'**
  String get addByScan;

  /// Option to add a book manually
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addByManual;

  /// Header for the main library section
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get libraryTitle;

  /// Total book count indicator
  ///
  /// In en, this message translates to:
  /// **'{count} Books'**
  String libraryCount(int count);

  /// Text when no books are registered in a list
  ///
  /// In en, this message translates to:
  /// **'No books registered'**
  String get noBooksRegistered;

  /// Tab for books currently being read
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get tabLibraryOne;

  /// Tab for books queued to read
  ///
  /// In en, this message translates to:
  /// **'To Read'**
  String get tabLibraryTwo;

  /// Tab for finished books
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get tabLibraryThree;

  /// Tab for dropped or paused books
  ///
  /// In en, this message translates to:
  /// **'Forgotten'**
  String get tabLibraryFour;

  /// Empty state for the Reading tab
  ///
  /// In en, this message translates to:
  /// **'No books are currently being read'**
  String get emptyReading;

  /// Empty state for the To Read tab
  ///
  /// In en, this message translates to:
  /// **'No books to read'**
  String get emptyToRead;

  /// Empty state for the Finished tab
  ///
  /// In en, this message translates to:
  /// **'No books finished yet'**
  String get emptyFinished;

  /// Empty state for the Forgotten tab
  ///
  /// In en, this message translates to:
  /// **'No books forgotten yet'**
  String get emptyDropped;

  /// AppBar title on the online search screen
  ///
  /// In en, this message translates to:
  /// **'Search Book'**
  String get searchTitle;

  /// Text for the search action button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// Placeholder hint inside the search text field
  ///
  /// In en, this message translates to:
  /// **'Title or author...'**
  String get searchPlaceholder;

  /// Initial hint displayed before searching
  ///
  /// In en, this message translates to:
  /// **'Type to search books online'**
  String get searchInitialHint;

  /// Title for manual entry flow
  ///
  /// In en, this message translates to:
  /// **'Add book manually'**
  String get addManualBook;

  /// Message displayed when a search returns no items
  ///
  /// In en, this message translates to:
  /// **'No search results found'**
  String get noSearchResults;

  /// AppBar title on the book detail confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Add book'**
  String get addBookTitle;

  /// Section header for general book information
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get sectionInfo;

  /// Section header for selecting the book's reading status
  ///
  /// In en, this message translates to:
  /// **'Select Reading Status'**
  String get sectionSelected;

  /// Section header for the book description or synopsis
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sectionDescription;

  /// Section header for publishing details
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get sectionPublisher;

  /// Section header for additional metadata like categories or ratings
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get sectionOther;

  /// Label for title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// Label for authors field
  ///
  /// In en, this message translates to:
  /// **'Author(s)'**
  String get fieldAuthors;

  /// Label for ISBN code field
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get fieldIsbn;

  /// Label for language field
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get fieldLanguage;

  /// Label for page count field
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get fieldPages;

  /// Label for publisher field
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get fieldPublisher;

  /// Label for publication date field
  ///
  /// In en, this message translates to:
  /// **'Publication date'**
  String get fieldPublishedDate;

  /// Label for book categories or genres
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get fieldCategories;

  /// Label for rating or score
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get fieldRating;

  /// Primary action button to save the book into the database
  ///
  /// In en, this message translates to:
  /// **'Save to library'**
  String get btnSaveToLibrary;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
