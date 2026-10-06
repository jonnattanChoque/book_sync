// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Hello,';

  @override
  String get welcomeMessage => 'Book lover';

  @override
  String get userName => 'Book Lover';

  @override
  String get addBook => 'Add book';

  @override
  String get currentlyReading => 'Reading now';

  @override
  String get createBookTitle => 'Add a book to your nightstand';

  @override
  String get noBooksTitle => 'Your nightstand is empty';

  @override
  String get noBooksSubtitle => 'What story shall we start today?';

  @override
  String get addBySearch => 'Add by search';

  @override
  String get addByScan => 'Add by scan (ISBN)';

  @override
  String get addByManual => 'Add manually';

  @override
  String get cameraAccessError => 'Error accessing camera';

  @override
  String get retry => 'Retry';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get accept => 'Accept';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String errorLoadingBooks(String error) {
    return 'Error loading books: $error';
  }

  @override
  String get ratingRequiredMessage => 'Please rate the book before finishing.';

  @override
  String get congratulationsFinishedTitle => 'Congratulations on finishing!';

  @override
  String get conclusionsHint => 'Write your final thoughts or review...';

  @override
  String get saveAndFinishButton => 'Save and Finish';

  @override
  String get skipRatingButton => 'Skip rating for now';

  @override
  String get rateThisBookAction => 'Rate this book';

  @override
  String get calendarTitle => 'Reading Calendar';

  @override
  String get exportMonthButton => 'Export Month';

  @override
  String get readingsForDateHeader => 'Day\'s Readings';

  @override
  String get noReadingsOnDate => 'No reading recorded for this day';

  @override
  String get addManualReading => 'Add log';

  @override
  String pagesAndDurationSummary(int pages, String duration) {
    String _temp0 = intl.Intl.pluralLogic(
      pages,
      locale: localeName,
      other: '$pages pages',
      one: '1 page',
    );
    return '$_temp0 • $duration';
  }

  @override
  String dayTotalSummary(String pages, String duration) {
    return 'Day Total: $pages • $duration';
  }

  @override
  String get authWelcomeTitle => 'Welcome to BookSync!';

  @override
  String get authWelcomeSubtitle =>
      'Sync your readings, keep your streaks, and take your stats anywhere.';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authContinueAsGuest => 'Explore as Guest';

  @override
  String get authGuestDisclaimer =>
      'You can use the app as a guest. To unlock Premium features and save your progress to the cloud, you\'ll need to sign in.';

  @override
  String get authLoginBenefitsTitle => 'Benefits of creating an account:';

  @override
  String get authBenefitSync => 'Cloud synchronization';

  @override
  String get authBenefitBackup => 'Automatic reading backup';

  @override
  String get authBenefitPremium => 'Unlock or restore Premium access';

  @override
  String get authSlideToSignOut => 'Slide to sign out';

  @override
  String get authSignOutSuccess => 'Signed out successfully';

  @override
  String get streakIncreased => 'Streak Increased!';

  @override
  String get streakCurrent => 'Current Streak';

  @override
  String get streakTitle => 'Reading Streak';

  @override
  String bestStreakLabel(Object count) {
    return 'Best streak: $count days';
  }

  @override
  String get currentStreakTitle => 'Current Streak';

  @override
  String get bestStreakTitle => 'Best Streak';

  @override
  String streakDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String streakDateRange(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get noActiveStreak => 'No active streak';

  @override
  String get readingCalendarTitle => 'Reading Calendar';

  @override
  String booksReadOnDate(Object count) {
    return 'Readings for the day ($count)';
  }

  @override
  String get noReadingOnDate => 'No reading sessions recorded for this day';

  @override
  String pagesReadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages read',
      one: '1 page read',
    );
    return '$_temp0';
  }

  @override
  String readingDayText(int days) {
    return 'Day $days';
  }

  @override
  String progressLabel(String percentage) {
    return '$percentage% completed';
  }

  @override
  String startDateWith(String date) {
    return 'Start: $date';
  }

  @override
  String remainingTime(String time) {
    return 'Remaining: $time';
  }

  @override
  String pageProgress(int currentPage, int totalPages) {
    return 'Page $currentPage / $totalPages';
  }

  @override
  String currentPageFormat(int currentPage) {
    return 'Page $currentPage';
  }

  @override
  String get progressInfo => 'Progress Information';

  @override
  String get startDate => 'Start';

  @override
  String get day => 'Day';

  @override
  String get remaining => 'Remaining';

  @override
  String get progress => 'Progress';

  @override
  String get pagesAbbr => 'pages';

  @override
  String get pageAbbr => 'Pg';

  @override
  String get minutesAbbr => 'min';

  @override
  String get libraryTitle => 'My Library';

  @override
  String get noBooksRegistered => 'No books registered';

  @override
  String libraryCount(int count) {
    return '$count Books';
  }

  @override
  String libraryOneCount(int count) {
    return '$count Books';
  }

  @override
  String get tabLibraryReading => 'Reading';

  @override
  String get tabLibraryToRead => 'To Read';

  @override
  String get tabLibraryRead => 'Read';

  @override
  String get tabLibraryDropped => 'Dropped';

  @override
  String get tabLibraryPaused => 'Paused';

  @override
  String get emptyReading => 'No books are currently being read';

  @override
  String get emptyToRead => 'No books to read';

  @override
  String get emptyFinished => 'No books finished yet';

  @override
  String get emptyDropped => 'No books dropped yet';

  @override
  String get errorLoadLibrary => 'Error loading library';

  @override
  String get favoritesFilterLabel => 'All your favorites';

  @override
  String get searchTitle => 'Search Book';

  @override
  String get searchButton => 'Search';

  @override
  String get searchPlaceholder => 'Title or author...';

  @override
  String get searchInitialHint => 'Type to search books online';

  @override
  String get noSearchResults => 'No results found';

  @override
  String get scanIsbnTitle => 'Scan ISBN Code';

  @override
  String get scanIsbnInstruction => 'Align barcode within frame';

  @override
  String get scanIsbnLoading => 'Searching book by ISBN...';

  @override
  String get bookNotFoundTitle => 'Book not found';

  @override
  String get searchByNamePrompt => 'Would you like to search by title?';

  @override
  String get duplicateBookTitle => 'Duplicate Book';

  @override
  String get duplicateBookMessage => 'This book is already in your library.';

  @override
  String get addNote => 'Note';

  @override
  String get readingNotes => 'Reading Notes';

  @override
  String get noNotesRegistered => 'No notes recorded for this book.';

  @override
  String get newReadingNote => 'New Reading Note';

  @override
  String get addNoteHint => 'Write your thought or quote from the book...';

  @override
  String get viewNotes => 'View notes';

  @override
  String get hideNotes => 'Hide notes';

  @override
  String get noNotesYet =>
      'You don\'t have any notes recorded for this book yet.';

  @override
  String get addNoteTitle => 'Add Note';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryQuote => 'Quote';

  @override
  String get categorySummary => 'Summary';

  @override
  String get categoryQuestion => 'Question';

  @override
  String get categoryReflection => 'Reflection';

  @override
  String get categoryIdea => 'Idea';

  @override
  String get categoryOther => 'Other';

  @override
  String get dateLabel => 'Date';

  @override
  String get pageLabel => 'Page';

  @override
  String pageOption(int page) {
    return 'Page $page';
  }

  @override
  String get noteLabel => 'Note';

  @override
  String get noteInputHint => 'Type your quote, summary, or reflection...';

  @override
  String get saveNoteButton => 'Save Note';

  @override
  String get errorEmptyPage => 'Please enter a valid page number';

  @override
  String errorInvalidPageRange(int totalPages) {
    return 'Page number cannot exceed $totalPages';
  }

  @override
  String get errorEmptyNote => 'Please enter content for the note';

  @override
  String get bookNotesTitle => 'Book notes';

  @override
  String errorLoadingNotes(String error) {
    return 'Error loading notes: $error';
  }

  @override
  String get emptyNotesMessage => 'No notes saved for this book';

  @override
  String get profileTitle => 'Profile';

  @override
  String get userDataSection => 'User Data';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get saveButton => 'Save changes';

  @override
  String get settingsSection => 'App Settings';

  @override
  String get themeTitle => 'App Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEs => 'Spanish';

  @override
  String get languageEn => 'English';

  @override
  String get remindersSection => 'Reminders';

  @override
  String get readingAlarmTitle => 'Reading Alarm';

  @override
  String get readingAlarmSubtitle =>
      'Set a daily notification to keep your streak going';

  @override
  String get goalsSection => 'Reading Goals';

  @override
  String get dailyGoal => 'Daily goal (minutes)';

  @override
  String get weeklyGoal => 'Weekly goal (books)';

  @override
  String get monthlyGoal => 'Monthly goal (books)';

  @override
  String get yearlyGoal => 'Yearly goal (books)';

  @override
  String get weeklyHoursGoal => 'Weekly goal (hours)';

  @override
  String get goalsSaved => 'Goals saved!';

  @override
  String get notificationChannelName => 'Reading Reminder';

  @override
  String get notificationChannelDescription =>
      'Daily notifications to remind you of your reading session';

  @override
  String get notificationTitle => 'Time to read! 📚';

  @override
  String get notificationBody =>
      'Keep up your daily streak and progress towards your reading goal.';

  @override
  String get notificationSaved => 'Alarm scheduled successfully!';

  @override
  String imageSelectionError(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhotoWithCamera => 'Take Photo with Camera';

  @override
  String get nameSavedSuccess => 'Name saved successfully!';

  @override
  String get imageSavedSuccess => 'Image saved successfully!';

  @override
  String get exportPreviewTitle => 'Export Summary';

  @override
  String get exportContentToInclude => 'Content to include';

  @override
  String get exportBackgroundStyle => 'Background Style';

  @override
  String get exportGenerating => 'Generating...';

  @override
  String get exportShareButton => 'Share Image';

  @override
  String exportDefaultShareText(Object appName) {
    return 'My reading statistics with $appName!';
  }

  @override
  String get exportPremiumTitle => 'Premium Feature';

  @override
  String exportPremiumDescription(Object appName) {
    return 'This exclusive background is part of $appName Premium. Unlock all gradients, textures, and full customization for your shared images.';
  }

  @override
  String get exportUpgradeButton => 'Get Premium';

  @override
  String get exportCancelButton => 'Maybe later';

  @override
  String get exportNoteTooltip => 'Export note as image';

  @override
  String exportNoteBy(String author) {
    return 'by $author';
  }

  @override
  String exportNoteShareText(String appName) {
    return 'A reading note from my current book with $appName! 📖✨';
  }

  @override
  String exportCalendarShareText(String appName) {
    return 'My monthly reading calendar summary with $appName! 📅📚';
  }

  @override
  String exportStreakShareText(String appName) {
    return 'My current reading streak on $appName! 🔥📖';
  }

  @override
  String get exportCustomizeTitle => 'Customize Export';

  @override
  String get exportCustomizeSubtitle =>
      'Drag to reorder and check the cards you want to include.';

  @override
  String get exportGeneratePreview => 'Generate Preview';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navStats => 'Stats';

  @override
  String get navProfile => 'Profile';

  @override
  String get yourBookTitle => 'Your Book';

  @override
  String get isbn => 'ISBN';

  @override
  String get deleteAction => 'Delete';

  @override
  String get editionInfo => 'Edition Information';

  @override
  String get publisher => 'Publisher';

  @override
  String get language => 'Language';

  @override
  String get publicationDate => 'Publication';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get readingStatusTitle => 'Reading Status';

  @override
  String get readingStatusMessage => 'Select current status for this book';

  @override
  String get statusReading => 'Reading';

  @override
  String get statusToRead => 'To Read';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusDropped => 'Dropped';

  @override
  String get statusFinished => 'Finished';

  @override
  String get deleteBookDialogTitle => 'Delete book';

  @override
  String deleteBookDialogMessage(String bookTitle) {
    return 'Are you sure you want to delete \"$bookTitle\"? This action cannot be undone.';
  }

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get bookStatusUpdated => 'Book status updated';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String statsTitle(Object date) {
    return 'Statistics $date';
  }

  @override
  String get statsDescription => 'Check your statistics here';

  @override
  String get statsYearlyGoalTitle => 'Yearly Goal';

  @override
  String statsYearlyGoalSub(int read, int target) {
    return '$read of $target books';
  }

  @override
  String get statsMonthlyBooksAvg => 'Monthly Books Avg';

  @override
  String get statsReadingSpeed => 'Reading Speed';

  @override
  String statsPagesPerHour(String pages) {
    return '$pages pages/h';
  }

  @override
  String get statsTotalYearlySummary => 'Yearly Totals';

  @override
  String statsTotalReadFormat(int hours, int minutes, int pages) {
    return '${hours}h ${minutes}m \n$pages pages';
  }

  @override
  String get statsBarChartTitle => 'Reading Activity';

  @override
  String get statsFilterMonthly => 'Month';

  @override
  String get statsFilterYearly => 'Year';

  @override
  String get statsPagesReadLabel => 'Pages read';

  @override
  String get statsHoursReadLabel => 'Hours read';

  @override
  String get statsMonthlyBooksSubtitle => 'Books read per month this year';

  @override
  String get statsBookCountSingular => 'book';

  @override
  String get statsBookCountPlural => 'books';

  @override
  String get statsYearFilterTooltip => 'Seleccionar año';

  @override
  String get statsSelectYearTitle => 'Seleccionar Año';

  @override
  String get statsNoDataForYearTitle => 'No reading records';

  @override
  String get statsNoDataForYearSubtitle =>
      'You didn\'t finish any books this year';

  @override
  String get statsReadingTimeChartTitle => 'Reading time per month';

  @override
  String get statsNoReadingTimeForYearTitle => 'No reading time recorded';

  @override
  String statsPagesCount(int count) {
    return '$count pgs';
  }

  @override
  String get statsRatingsChartTitle => 'Rating distribution';

  @override
  String get statsNoRatingsForYearTitle => 'No ratings for this year';

  @override
  String statsBooksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books',
      one: '1 book',
    );
    return '$_temp0';
  }

  @override
  String get statsCategoriesChartTitle => 'Category distribution';

  @override
  String get statsNoCategoriesForYearTitle => 'No categories for this year';

  @override
  String statsBooksInCategory(String category) {
    return 'Books in $category:';
  }

  @override
  String get statsWeeklyHoursGoalTitle => 'Weekly Goal';

  @override
  String statsWeeklyHoursGoalSub(String hours, Object goals) {
    return '$hours hours of $goals';
  }

  @override
  String get statsTopGenresTitle => 'Top 3 Genres';

  @override
  String get statsCurrentStreakTitle => 'Current Streak';

  @override
  String get statsReadingRecordTitle => 'Reading Record';

  @override
  String statsStreakDaysFormat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String get statsNoData => 'No data yet';

  @override
  String statsPagesReadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get addManualBook => 'Add book manually';

  @override
  String get addBookTitle => 'Add book';

  @override
  String get sectionInfo => 'Information';

  @override
  String get sectionSelected => 'Select reading status';

  @override
  String get sectionDescription => 'Description';

  @override
  String get sectionPublisher => 'Publisher';

  @override
  String get sectionOther => 'Other';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldAuthors => 'Author(s)';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldLanguage => 'Language';

  @override
  String get fieldPages => 'Pages';

  @override
  String get fieldPublisher => 'Publisher';

  @override
  String get fieldPublishedDate => 'Publication Date';

  @override
  String get fieldCategories => 'Categories';

  @override
  String get fieldRating => 'Rating';

  @override
  String get btnSaveToLibrary => 'Save to library';

  @override
  String get searchImageTitle => 'Search Cover Image';

  @override
  String get searchImageHint => 'Type to search images online';

  @override
  String get validationTitleRequired => 'Title is required';

  @override
  String get confirmChangeCoverTitle => 'Change Cover';

  @override
  String get confirmChangeCoverMessage =>
      'Do you want to replace the current cover with this image?';

  @override
  String get validationTotalPagesRequired => 'Total pages is required';

  @override
  String get validationTotalPagesInvalid =>
      'Enter a valid number of pages greater than 0';

  @override
  String get newSession => 'Read';

  @override
  String get readingHistory => 'Reading History';

  @override
  String get noSessionsRegistered =>
      'You haven\'t recorded any reading sessions yet.';

  @override
  String pagesRange(int startPage, int endPage) {
    return 'Pages $startPage to $endPage';
  }

  @override
  String upToPage(int endPage) {
    return 'Up to page $endPage';
  }

  @override
  String get readingSessionTitle => 'Reading Session';

  @override
  String get timerStart => 'Start';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerPause => 'Pause';

  @override
  String get finishSession => 'Finish';

  @override
  String get finishReadingTitle => 'Finish Reading';

  @override
  String get timeReadLabel => 'Time Read';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsShort => 's';

  @override
  String get whatPageDidYouReach => 'What page did you reach?';

  @override
  String currentPageHint(int page, int lastPage) {
    return 'Current page ($page/$lastPage)';
  }

  @override
  String get saveSessionButton => 'Save Session';

  @override
  String get validationEnterEndPage => 'Enter the final page';

  @override
  String get validationInvalidNumber => 'Enter a valid number';

  @override
  String validationPageLowerThanCurrent(int currentPage) {
    return 'Cannot be lower than previous page ($currentPage)';
  }

  @override
  String validationPageExceedsTotal(int totalPages) {
    return 'Cannot exceed total book pages ($totalPages)';
  }

  @override
  String get sessionSummaryTitle => 'Summary';

  @override
  String get pagesReadLabel => 'Pages read';

  @override
  String get readingSpeedLabel => 'Reading speed';

  @override
  String pagesPerMinute(String speed) {
    return '$speed pages/min';
  }

  @override
  String get estimatedTimeRemaining => 'Est. time remaining';

  @override
  String get doneButton => 'Done';

  @override
  String get sessionResultTitle => 'Reading Session Result';

  @override
  String readSummaryInfo(int pages, String duration) {
    return 'You read $pages pages in $duration.';
  }

  @override
  String readingSpeedInfo(String pagesPerHour) {
    return 'This is your average reading speed: $pagesPerHour pages per hour.';
  }

  @override
  String timeRemainingInfo(String timeRemaining) {
    return 'Estimated time left to finish is $timeRemaining.';
  }

  @override
  String pagesRemainingInfo(int pagesRemaining) {
    return 'There are $pagesRemaining pages left to finish your book.';
  }

  @override
  String get registerReadingTitle => 'Registrar Lectura';

  @override
  String get selectBookLabel => 'Selecciona el libro';

  @override
  String get readingTimeLabel => 'Tiempo de lectura';

  @override
  String get noBooksCurrentlyReading =>
      'No tienes libros en curso actualmente.';

  @override
  String get selectBookWarning => 'Por favor selecciona un libro';

  @override
  String get selectDateLabel => 'Reading date';

  @override
  String get todayLabel => 'Today';
}
