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
  /// **'Hello,'**
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
  String progressLabel(String percentage);

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
  String get tabLibraryReading;

  /// Tab for books queued to read
  ///
  /// In en, this message translates to:
  /// **'To Read'**
  String get tabLibraryToRead;

  /// Tab for finished books
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get tabLibraryRead;

  /// Tab for dropped books
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get tabLibraryDropped;

  /// Tab for paused books
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get tabLibraryPaused;

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

  /// Empty state for the dropped tab
  ///
  /// In en, this message translates to:
  /// **'No books dropped yet'**
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
  /// **'Add book'**
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

  /// Main title for the ISBN barcode scanner screen.
  ///
  /// In en, this message translates to:
  /// **'Scan ISBN Code'**
  String get scanIsbnTitle;

  /// Instruction text guiding the user to frame the barcode within the camera view.
  ///
  /// In en, this message translates to:
  /// **'Align barcode here'**
  String get scanIsbnInstruction;

  /// Loading message displayed while querying the book via API.
  ///
  /// In en, this message translates to:
  /// **'Searching book by ISBN...'**
  String get scanIsbnLoading;

  /// Title of the screen or modal for searching book covers.
  ///
  /// In en, this message translates to:
  /// **'Search image'**
  String get searchImageTitle;

  /// Placeholder text for the search input field.
  ///
  /// In en, this message translates to:
  /// **'Type to search images on the web'**
  String get searchImageHint;

  /// Title of the confirmation dialog to replace the book cover.
  ///
  /// In en, this message translates to:
  /// **'Change cover'**
  String get confirmChangeCoverTitle;

  /// Main body message of the confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Do you want to replace the current cover with this image?'**
  String get confirmChangeCoverMessage;

  /// Label for the cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Label for the confirm/accept button.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// Title of the dialog warning that a book is already in the library.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Book'**
  String get duplicateBookTitle;

  /// Explanatory message informing the user that the entered ISBN is already registered.
  ///
  /// In en, this message translates to:
  /// **'This book is already in your library.'**
  String get duplicateBookMessage;

  /// Text for the primary button to close or confirm an alert dialog.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Main title in the AppBar of the book details screen
  ///
  /// In en, this message translates to:
  /// **'Your book'**
  String get yourBookTitle;

  /// Label for the book ISBN
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get isbn;

  /// Text for the delete button or action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Title of the publisher/edition info card
  ///
  /// In en, this message translates to:
  /// **'Edition Information'**
  String get editionInfo;

  /// Label for the book publisher
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// Label for the book language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for the book publication date
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get publicationDate;

  /// Title of the synopsis or description section
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// Button text for adding a quick note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get addNote;

  /// Button text for starting a new reading session
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get newSession;

  /// Title of the expandable notes section
  ///
  /// In en, this message translates to:
  /// **'Reading Notes'**
  String get readingNotes;

  /// Message when no notes have been created for the book
  ///
  /// In en, this message translates to:
  /// **'No notes recorded for this book.'**
  String get noNotesRegistered;

  /// Title of the expandable session history section
  ///
  /// In en, this message translates to:
  /// **'Reading History'**
  String get readingHistory;

  /// Message when no sessions are recorded
  ///
  /// In en, this message translates to:
  /// **'You haven\'t recorded any reading sessions yet.'**
  String get noSessionsRegistered;

  /// Title of the progress and reading time card
  ///
  /// In en, this message translates to:
  /// **'Progress Information'**
  String get progressInfo;

  /// Label for the reading start date
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startDate;

  /// Label for the current or elapsed reading day
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Label for the estimated remaining reading time
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Text preceding the progress percentage
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Abbreviation for pages
  ///
  /// In en, this message translates to:
  /// **'pages'**
  String get pagesAbbr;

  /// Singular abbreviation for page
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get pageAbbr;

  /// Abbreviation for minutes
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesAbbr;

  /// Title for the status selection sheet
  ///
  /// In en, this message translates to:
  /// **'Reading Status'**
  String get readingStatusTitle;

  /// Instruction message for the status menu
  ///
  /// In en, this message translates to:
  /// **'Select the current status for this book'**
  String get readingStatusMessage;

  /// Status: Reading
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get statusReading;

  /// Status: To Read
  ///
  /// In en, this message translates to:
  /// **'To Read'**
  String get statusToRead;

  /// Status: On Hold
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get statusPaused;

  /// Status: Dropped
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get statusDropped;

  /// Status: Finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get statusFinished;

  /// Generic text to cancel dialogs or actions
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic text to save changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Title of the add note modal
  ///
  /// In en, this message translates to:
  /// **'New Reading Note'**
  String get newReadingNote;

  /// Placeholder inside the note text field
  ///
  /// In en, this message translates to:
  /// **'Write your reflection or quote from the book...'**
  String get addNoteHint;

  /// Title of the delete confirmation modal
  ///
  /// In en, this message translates to:
  /// **'Delete book'**
  String get deleteBookDialogTitle;

  /// Confirmation message to delete a book specifying its title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{bookTitle}\"? This action cannot be undone.'**
  String deleteBookDialogMessage(String bookTitle);

  /// Confirmation message when a book is added to favorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Confirmation message when a book is removed from favorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Confirmation message after changing a book's reading status.
  ///
  /// In en, this message translates to:
  /// **'Book status updated'**
  String get bookStatusUpdated;

  /// Text for the range of pages read in a session
  ///
  /// In en, this message translates to:
  /// **'Pages {startPage} to {endPage}'**
  String pagesRange(int startPage, int endPage);

  /// Text indicating the end page when no start page is recorded
  ///
  /// In en, this message translates to:
  /// **'Up to page {endPage}'**
  String upToPage(int endPage);

  /// Main title of the active reading session screen or modal.
  ///
  /// In en, this message translates to:
  /// **'Reading Session'**
  String get readingSessionTitle;

  /// Button label to start the reading timer for the first time.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timerStart;

  /// Button label to resume the reading timer after being paused.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get timerResume;

  /// Button label to temporarily pause the reading timer.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// Button to expand the notes list inside the reading view.
  ///
  /// In en, this message translates to:
  /// **'View notes'**
  String get viewNotes;

  /// Button text when the notes list is currently expanded.
  ///
  /// In en, this message translates to:
  /// **'Hide notes'**
  String get hideNotes;

  /// Primary button to stop the timer and log reading progress.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishSession;

  /// Informational message when the book has no notes.
  ///
  /// In en, this message translates to:
  /// **'No notes registered for this book yet.'**
  String get noNotesYet;

  /// Main title of the modal for creating a new note.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNoteTitle;

  /// Label for the category selection section.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// Category for book quotes.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get categoryQuote;

  /// Category for summaries.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get categorySummary;

  /// Category for questions or doubts.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get categoryQuestion;

  /// Category for personal reflections.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get categoryReflection;

  /// Category for ideas.
  ///
  /// In en, this message translates to:
  /// **'Idea'**
  String get categoryIdea;

  /// General category.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// Label for the date field.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// Label for the page field.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get pageLabel;

  /// Dropdown option indicating page number.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageOption(int page);

  /// Label for the note text input field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// Placeholder text inside the note text area.
  ///
  /// In en, this message translates to:
  /// **'Write your quote, summary, or reflection...'**
  String get noteInputHint;

  /// Button to confirm and save the note.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNoteButton;

  /// Error message when the page field is empty or not a number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid page'**
  String get errorEmptyPage;

  /// Error message when page number exceeds total book pages.
  ///
  /// In en, this message translates to:
  /// **'Page cannot exceed {totalPages}'**
  String errorInvalidPageRange(int totalPages);

  /// Error message when note text field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter note content'**
  String get errorEmptyNote;

  /// Main title of the modal when ending a reading session.
  ///
  /// In en, this message translates to:
  /// **'Finish reading'**
  String get finishReadingTitle;

  /// Label for the total duration of the session.
  ///
  /// In en, this message translates to:
  /// **'Time read'**
  String get timeReadLabel;

  /// Abbreviation for minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// Abbreviation for seconds.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsShort;

  /// Label for the input where the user enters the reached page.
  ///
  /// In en, this message translates to:
  /// **'What page did you reach?'**
  String get whatPageDidYouReach;

  /// Hint text for the page input field.
  ///
  /// In en, this message translates to:
  /// **'Current page (e.g. {page})'**
  String currentPageHint(int page);

  /// Text for the main button to save the reading entry.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get saveSessionButton;

  /// Error message when the page field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the end page'**
  String get validationEnterEndPage;

  /// Error message when the input value is not a valid integer.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validationInvalidNumber;

  /// Error message when the end page is lower than the starting page.
  ///
  /// In en, this message translates to:
  /// **'Cannot be lower than the previous page ({currentPage})'**
  String validationPageLowerThanCurrent(int currentPage);

  /// Error message when the entered page exceeds total book pages.
  ///
  /// In en, this message translates to:
  /// **'Cannot exceed total pages ({totalPages})'**
  String validationPageExceedsTotal(int totalPages);

  /// Main title for session summary page.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get sessionSummaryTitle;

  /// Label for amount of pages read.
  ///
  /// In en, this message translates to:
  /// **'Pages read'**
  String get pagesReadLabel;

  /// Label for reading speed in pages per minute.
  ///
  /// In en, this message translates to:
  /// **'Reading speed'**
  String get readingSpeedLabel;

  /// Format for reading speed.
  ///
  /// In en, this message translates to:
  /// **'{speed} pages/min'**
  String pagesPerMinute(String speed);

  /// Label for estimated time left to finish the book.
  ///
  /// In en, this message translates to:
  /// **'Est. time remaining'**
  String get estimatedTimeRemaining;

  /// Main button to save and go back home.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// Main title of the summary view when done reading.
  ///
  /// In en, this message translates to:
  /// **'Reading Session Result'**
  String get sessionResultTitle;

  /// Informs how many pages the user read and the session duration.
  ///
  /// In en, this message translates to:
  /// **'You read {pages} pages in {duration}.'**
  String readSummaryInfo(int pages, String duration);

  /// Displays average reading speed per hour.
  ///
  /// In en, this message translates to:
  /// **'This is your average reading speed: {pagesPerHour} pages per hour.'**
  String readingSpeedInfo(String pagesPerHour);

  /// Displays estimated time left to complete the book.
  ///
  /// In en, this message translates to:
  /// **'Time left to finish is {timeRemaining}.'**
  String timeRemainingInfo(String timeRemaining);

  /// Indicates how many pages remain to complete the book.
  ///
  /// In en, this message translates to:
  /// **'There are {pagesRemaining} pages left to finish your book.'**
  String pagesRemainingInfo(int pagesRemaining);
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
