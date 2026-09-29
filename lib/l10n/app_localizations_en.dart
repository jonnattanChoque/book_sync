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
  String get welcomeMessage => 'Stories reader';

  @override
  String get userName => 'Story Reader';

  @override
  String get addBook => 'Add book';

  @override
  String get currentlyReading => 'Currently reading';

  @override
  String progressLabel(String percentage) {
    return '$percentage% completed';
  }

  @override
  String get createBookTitle => 'Add a book to your nightstand';

  @override
  String get noBooksTitle => 'Your nightstand is empty';

  @override
  String get noBooksSubtitle => 'What story will we start today?';

  @override
  String get addBySearch => 'Add by search';

  @override
  String get addByScan => 'Add by scan (ISBN)';

  @override
  String get addByManual => 'Add manually';

  @override
  String get libraryTitle => 'My Library';

  @override
  String libraryCount(int count) {
    return '$count Books';
  }

  @override
  String get noBooksRegistered => 'No books registered';

  @override
  String get tabLibraryReading => 'Reading';

  @override
  String get tabLibraryToRead => 'To Read';

  @override
  String get tabLibraryRead => 'Read';

  @override
  String get tabLibraryDropped => 'Dropped';

  @override
  String get tabLibraryPaused => 'Dropped';

  @override
  String get emptyReading => 'No books are currently being read';

  @override
  String get emptyToRead => 'No books to read';

  @override
  String get emptyFinished => 'No books finished yet';

  @override
  String get emptyDropped => 'No books dropped yet';

  @override
  String get searchTitle => 'Search Book';

  @override
  String get searchButton => 'Search';

  @override
  String get searchPlaceholder => 'Title or author...';

  @override
  String get searchInitialHint => 'Type to search books online';

  @override
  String get addManualBook => 'Add book';

  @override
  String get noSearchResults => 'No search results found';

  @override
  String get addBookTitle => 'Add book';

  @override
  String get sectionInfo => 'Information';

  @override
  String get sectionSelected => 'Select Reading Status';

  @override
  String get sectionDescription => 'Description';

  @override
  String get sectionPublisher => 'Publisher';

  @override
  String get sectionOther => 'Others';

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
  String get fieldPublishedDate => 'Publication date';

  @override
  String get fieldCategories => 'Categories';

  @override
  String get fieldRating => 'Rating';

  @override
  String get btnSaveToLibrary => 'Save to library';

  @override
  String get scanIsbnTitle => 'Scan ISBN Code';

  @override
  String get scanIsbnInstruction => 'Align barcode here';

  @override
  String get scanIsbnLoading => 'Searching book by ISBN...';

  @override
  String get searchImageTitle => 'Search image';

  @override
  String get searchImageHint => 'Type to search images on the web';

  @override
  String get confirmChangeCoverTitle => 'Change cover';

  @override
  String get confirmChangeCoverMessage =>
      'Do you want to replace the current cover with this image?';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get duplicateBookTitle => 'Duplicate Book';

  @override
  String get duplicateBookMessage => 'This book is already in your library.';

  @override
  String get accept => 'Accept';

  @override
  String get yourBookTitle => 'Your book';

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
  String get publicationDate => 'Published';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get addNote => 'Note';

  @override
  String get newSession => 'Read';

  @override
  String get readingNotes => 'Reading Notes';

  @override
  String get noNotesRegistered => 'No notes recorded for this book.';

  @override
  String get readingHistory => 'Reading History';

  @override
  String get noSessionsRegistered =>
      'You haven\'t recorded any reading sessions yet.';

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
  String get pageAbbr => 'Page';

  @override
  String get minutesAbbr => 'min';

  @override
  String get readingStatusTitle => 'Reading Status';

  @override
  String get readingStatusMessage => 'Select the current status for this book';

  @override
  String get statusReading => 'Reading';

  @override
  String get statusToRead => 'To Read';

  @override
  String get statusPaused => 'On Hold';

  @override
  String get statusDropped => 'Dropped';

  @override
  String get statusFinished => 'Finished';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get newReadingNote => 'New Reading Note';

  @override
  String get addNoteHint => 'Write your reflection or quote from the book...';

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
  String get viewNotes => 'View notes';

  @override
  String get hideNotes => 'Hide notes';

  @override
  String get finishSession => 'Finish';

  @override
  String get noNotesYet => 'No notes registered for this book yet.';

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
  String get noteInputHint => 'Write your quote, summary, or reflection...';

  @override
  String get saveNoteButton => 'Save Note';

  @override
  String get errorEmptyPage => 'Enter a valid page';

  @override
  String errorInvalidPageRange(int totalPages) {
    return 'Page cannot exceed $totalPages';
  }

  @override
  String get errorEmptyNote => 'Please enter note content';

  @override
  String get finishReadingTitle => 'Finish reading';

  @override
  String get timeReadLabel => 'Time read';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsShort => 's';

  @override
  String get whatPageDidYouReach => 'What page did you reach?';

  @override
  String currentPageHint(int page) {
    return 'Current page (e.g. $page)';
  }

  @override
  String get saveSessionButton => 'Save session';

  @override
  String get validationEnterEndPage => 'Please enter the end page';

  @override
  String get validationInvalidNumber => 'Please enter a valid number';

  @override
  String validationPageLowerThanCurrent(int currentPage) {
    return 'Cannot be lower than the previous page ($currentPage)';
  }

  @override
  String validationPageExceedsTotal(int totalPages) {
    return 'Cannot exceed total pages ($totalPages)';
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
    return 'Time left to finish is $timeRemaining.';
  }

  @override
  String pagesRemainingInfo(int pagesRemaining) {
    return 'There are $pagesRemaining pages left to finish your book.';
  }
}
