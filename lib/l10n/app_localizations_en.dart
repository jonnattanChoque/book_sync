// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Good afternoon,';

  @override
  String get welcomeMessage => 'Stories reader';

  @override
  String get userName => 'Story Reader';

  @override
  String get addBook => 'Add book';

  @override
  String get currentlyReading => 'Currently reading';

  @override
  String progressLabel(int percentage) {
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
  String get tabLibraryOne => 'Reading';

  @override
  String get tabLibraryTwo => 'To Read';

  @override
  String get tabLibraryThree => 'Read';

  @override
  String get tabLibraryFour => 'Forgotten';

  @override
  String get emptyReading => 'No books are currently being read';

  @override
  String get emptyToRead => 'No books to read';

  @override
  String get emptyFinished => 'No books finished yet';

  @override
  String get emptyDropped => 'No books forgotten yet';

  @override
  String get searchTitle => 'Search Book';

  @override
  String get searchButton => 'Search';

  @override
  String get searchPlaceholder => 'Title or author...';

  @override
  String get searchInitialHint => 'Type to search books online';

  @override
  String get addManualBook => 'Add book manually';

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
}
