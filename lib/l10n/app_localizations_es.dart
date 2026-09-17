// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => 'Buenas tardes,';

  @override
  String get welcomeMessage => 'Lector de historias';

  @override
  String get userName => 'Lector de Historias';

  @override
  String get addBook => 'Agregar libro';

  @override
  String get currentlyReading => 'Leyendo ahora';

  @override
  String progressLabel(int percentage) {
    return '$percentage% completado';
  }

  @override
  String get createBookTitle => 'Agrega un libro a tu mesa de noche';

  @override
  String get noBooksTitle => 'Tu mesa de noche está vacía';

  @override
  String get noBooksSubtitle => '¿Qué historia empezaremos hoy?';

  @override
  String get addBySearch => 'Agregar por búsqueda';

  @override
  String get addByScan => 'Agregar por código (ISBN)';

  @override
  String get addByManual => 'Agregar manualmente';

  @override
  String get libraryTitle => 'Mi Biblioteca';

  @override
  String libraryCount(int count) {
    return '$count Libros';
  }

  @override
  String get noBooksRegistered => 'No hay libros registrados';

  @override
  String get tabLibraryOne => 'Leyendo';

  @override
  String get tabLibraryTwo => 'Por leer';

  @override
  String get tabLibraryThree => 'Leídos';

  @override
  String get tabLibraryFour => 'Olvidados';

  @override
  String get emptyReading => 'No hay libros en lectura';

  @override
  String get emptyToRead => 'No hay libros por leer';

  @override
  String get emptyFinished => 'No hay libros leídos aún';

  @override
  String get emptyDropped => 'No hay libros olvidados aún';

  @override
  String get searchTitle => 'Buscar Libro';

  @override
  String get searchButton => 'Buscar';

  @override
  String get searchPlaceholder => 'Título o autor...';

  @override
  String get searchInitialHint => 'Escribe para buscar libros en la red';

  @override
  String get addManualBook => 'Agregar libro manualmente';

  @override
  String get noSearchResults => 'No se encontraron resultados';

  @override
  String get addBookTitle => 'Agregar libro';

  @override
  String get sectionInfo => 'Información';

  @override
  String get sectionSelected => 'Seleccione el estado de lectura';

  @override
  String get sectionDescription => 'Descripción';

  @override
  String get sectionPublisher => 'Editorial';

  @override
  String get sectionOther => 'Otros';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldAuthors => 'Autor(es)';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldLanguage => 'Idioma';

  @override
  String get fieldPages => 'Páginas';

  @override
  String get fieldPublisher => 'Editorial';

  @override
  String get fieldPublishedDate => 'Fecha de publicación';

  @override
  String get fieldCategories => 'Categorías';

  @override
  String get fieldRating => 'Valoración';

  @override
  String get btnSaveToLibrary => 'Guardar en la biblioteca';
}
