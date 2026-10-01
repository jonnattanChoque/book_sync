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

  /// Saludo inicial en la pantalla principal
  ///
  /// In es, this message translates to:
  /// **'Hola,'**
  String get welcomeTitle;

  /// Subtítulo de bienvenida en la pantalla principal
  ///
  /// In es, this message translates to:
  /// **'Lector de historias'**
  String get welcomeMessage;

  /// Nombre por defecto del usuario
  ///
  /// In es, this message translates to:
  /// **'Lector de Historias'**
  String get userName;

  /// Texto del botón o acción general para agregar un libro
  ///
  /// In es, this message translates to:
  /// **'Agregar libro'**
  String get addBook;

  /// Encabezado de la sección del libro en lectura actual
  ///
  /// In es, this message translates to:
  /// **'Leyendo ahora'**
  String get currentlyReading;

  /// Título en la vista o diálogo modal de adición de libros
  ///
  /// In es, this message translates to:
  /// **'Agrega un libro a tu mesa de noche'**
  String get createBookTitle;

  /// Título del estado vacío de la biblioteca principal
  ///
  /// In es, this message translates to:
  /// **'Tu mesa de noche está vacía'**
  String get noBooksTitle;

  /// Mensaje motivacional cuando no hay libros registrados
  ///
  /// In es, this message translates to:
  /// **'¿Qué historia empezaremos hoy?'**
  String get noBooksSubtitle;

  /// Opción para agregar libro mediante búsqueda en la API
  ///
  /// In es, this message translates to:
  /// **'Agregar por búsqueda'**
  String get addBySearch;

  /// Opción para agregar libro escaneando código de barras
  ///
  /// In es, this message translates to:
  /// **'Agregar por código (ISBN)'**
  String get addByScan;

  /// Opción para agregar libro con formulario manual
  ///
  /// In es, this message translates to:
  /// **'Agregar manualmente'**
  String get addByManual;

  /// Mensaje de error desplegado cuando el controlador no puede iniciar el hardware de la cámara.
  ///
  /// In es, this message translates to:
  /// **'Error al acceder a la cámara'**
  String get cameraAccessError;

  /// Texto para el botón que permite reintentar una acción fallida.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Etiqueta para el botón de cancelar la acción.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get actionCancel;

  /// Etiqueta para el botón de aceptar o confirmar el cambio de portada.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get actionConfirm;

  /// Texto del botón principal para cerrar o confirmar un diálogo de alerta.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// Texto genérico para cancelar diálogos o acciones
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Texto genérico para guardar cambios
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// Mensaje desplegado cuando ocurre un fallo al obtener la lista de libros.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar libros: {error}'**
  String errorLoadingBooks(String error);

  /// Mensaje de advertencia en SnackBar cuando el usuario intenta salir del resumen de un libro terminado sin haberlo calificado.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa tu valoración del libro para finalizar.'**
  String get ratingRequiredMessage;

  /// Título principal en el modal de valoración de un libro completado.
  ///
  /// In es, this message translates to:
  /// **'¡Felicidades por terminarlo!'**
  String get congratulationsFinishedTitle;

  /// Texto de sugerencia en el campo para redactar la reseña o conclusiones finales del libro.
  ///
  /// In es, this message translates to:
  /// **'Escribe tus conclusiones o reseña final...'**
  String get conclusionsHint;

  /// Botón principal para guardar la calificación y las conclusiones finales.
  ///
  /// In es, this message translates to:
  /// **'Guardar y Concluir'**
  String get saveAndFinishButton;

  /// Texto del botón secundario para omitir la valoración del libro en el modal.
  ///
  /// In es, this message translates to:
  /// **'No valorar por ahora'**
  String get skipRatingButton;

  /// Texto del botón en la pantalla de resumen para reabrir el modal de valoración si el usuario lo cerró.
  ///
  /// In es, this message translates to:
  /// **'Valorar este libro'**
  String get rateThisBookAction;

  /// No description provided for @streakIncreased.
  ///
  /// In es, this message translates to:
  /// **'¡Racha Aumentada!'**
  String get streakIncreased;

  /// No description provided for @streakCurrent.
  ///
  /// In es, this message translates to:
  /// **'Racha Actual'**
  String get streakCurrent;

  /// No description provided for @streakTitle.
  ///
  /// In es, this message translates to:
  /// **'Racha de lectura'**
  String get streakTitle;

  /// No description provided for @bestStreakLabel.
  ///
  /// In es, this message translates to:
  /// **'Mejor racha: {count} días'**
  String bestStreakLabel(Object count);

  /// Título de la tarjeta para la racha actual de días consecutivos.
  ///
  /// In es, this message translates to:
  /// **'Racha actual'**
  String get currentStreakTitle;

  /// Título de la tarjeta para el récord histórico de racha de lectura.
  ///
  /// In es, this message translates to:
  /// **'Mejor racha'**
  String get bestStreakTitle;

  /// Cantidad de días de racha.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 día} other{{count} días}}'**
  String streakDaysCount(int count);

  /// Rango de fechas de la racha.
  ///
  /// In es, this message translates to:
  /// **'{startDate} - {endDate}'**
  String streakDateRange(String startDate, String endDate);

  /// Texto desplegado cuando no hay una racha activa.
  ///
  /// In es, this message translates to:
  /// **'Sin racha activa'**
  String get noActiveStreak;

  /// Título de la sección del calendario de lecturas.
  ///
  /// In es, this message translates to:
  /// **'Calendario de lectura'**
  String get readingCalendarTitle;

  /// Encabezado para los libros leídos en la fecha seleccionada.
  ///
  /// In es, this message translates to:
  /// **'Lecturas del día ({count})'**
  String booksReadOnDate(Object count);

  /// Mensaje cuando no hay registros de lectura en la fecha seleccionada.
  ///
  /// In es, this message translates to:
  /// **'No registraste lecturas este día'**
  String get noReadingOnDate;

  /// Conteo total de páginas leídas en el día.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 página leída} other{{count} páginas leídas}}'**
  String pagesReadCount(int count);

  /// Indica el número de día transcurrido en el reto o racha de lectura
  ///
  /// In es, this message translates to:
  /// **'Día {days}'**
  String readingDayText(int days);

  /// Porcentaje de avance en la lectura de un libro
  ///
  /// In es, this message translates to:
  /// **'{percentage}% completado'**
  String progressLabel(String percentage);

  /// Muestra la fecha de inicio de lectura del libro.
  ///
  /// In es, this message translates to:
  /// **'Inicio: {date}'**
  String startDateWith(String date);

  /// Tiempo estimado restante para finalizar el libro.
  ///
  /// In es, this message translates to:
  /// **'Restante: {time}'**
  String remainingTime(String time);

  /// Progreso de lectura expresado en página actual y total.
  ///
  /// In es, this message translates to:
  /// **'Pág. {currentPage} / {totalPages}'**
  String pageProgress(int currentPage, int totalPages);

  /// Formato simple para indicar la página actual alcanzada.
  ///
  /// In es, this message translates to:
  /// **'Pág. {currentPage}'**
  String currentPageFormat(int currentPage);

  /// Título de la tarjeta de progreso y tiempos de lectura
  ///
  /// In es, this message translates to:
  /// **'Información de progreso'**
  String get progressInfo;

  /// Etiqueta para la fecha de inicio de lectura
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get startDate;

  /// Etiqueta para el día actual o transcurrido de lectura
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get day;

  /// Etiqueta para el tiempo estimado restante de lectura
  ///
  /// In es, this message translates to:
  /// **'Restante'**
  String get remaining;

  /// Texto que precede al porcentaje de avance
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get progress;

  /// Abreviatura de páginas
  ///
  /// In es, this message translates to:
  /// **'págs'**
  String get pagesAbbr;

  /// Abreviatura singular de página
  ///
  /// In es, this message translates to:
  /// **'Pág'**
  String get pageAbbr;

  /// Abreviatura de minutos
  ///
  /// In es, this message translates to:
  /// **'min'**
  String get minutesAbbr;

  /// Título principal de la sección de biblioteca
  ///
  /// In es, this message translates to:
  /// **'Mi Biblioteca'**
  String get libraryTitle;

  /// Texto indicativo para listas de biblioteca sin elementos
  ///
  /// In es, this message translates to:
  /// **'No hay libros registrados'**
  String get noBooksRegistered;

  /// Contador del total de libros guardados
  ///
  /// In es, this message translates to:
  /// **'{count} Libros'**
  String libraryCount(int count);

  /// Contador del total de libros guardados
  ///
  /// In es, this message translates to:
  /// **'{count} Libro'**
  String libraryOneCount(int count);

  /// Pestaña de libros en proceso de lectura
  ///
  /// In es, this message translates to:
  /// **'Leyendo'**
  String get tabLibraryReading;

  /// Pestaña de libros pendientes de lectura
  ///
  /// In es, this message translates to:
  /// **'Por leer'**
  String get tabLibraryToRead;

  /// Pestaña de libros terminados
  ///
  /// In es, this message translates to:
  /// **'Leídos'**
  String get tabLibraryRead;

  /// Pestaña de libros abandonados
  ///
  /// In es, this message translates to:
  /// **'Abandonados'**
  String get tabLibraryDropped;

  /// Pestaña de libros pausados
  ///
  /// In es, this message translates to:
  /// **'Pausados'**
  String get tabLibraryPaused;

  /// Estado vacío de la pestaña leyendo
  ///
  /// In es, this message translates to:
  /// **'No hay libros en lectura'**
  String get emptyReading;

  /// Estado vacío de la pestaña por leer
  ///
  /// In es, this message translates to:
  /// **'No hay libros por leer'**
  String get emptyToRead;

  /// Estado vacío de la pestaña leídos
  ///
  /// In es, this message translates to:
  /// **'No hay libros leídos aún'**
  String get emptyFinished;

  /// Estado vacío de la pestaña abandonados
  ///
  /// In es, this message translates to:
  /// **'No hay libros abandonados aún'**
  String get emptyDropped;

  /// Error al cargar la biblioteca
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la biblioteca'**
  String get errorLoadLibrary;

  /// Texto para el botón de filtro de libros favoritos debajo de los tabs de la biblioteca
  ///
  /// In es, this message translates to:
  /// **'Todos tus favoritos'**
  String get favoritesFilterLabel;

  /// Título del AppBar en la pantalla de búsqueda online
  ///
  /// In es, this message translates to:
  /// **'Buscar Libro'**
  String get searchTitle;

  /// Texto del botón de la barra de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get searchButton;

  /// Hint text dentro del campo de texto de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Título o autor...'**
  String get searchPlaceholder;

  /// Mensaje informativo en el centro de la pantalla antes de buscar
  ///
  /// In es, this message translates to:
  /// **'Escribe para buscar libros en la red'**
  String get searchInitialHint;

  /// Mensaje de búsqueda sin coincidencias
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados'**
  String get noSearchResults;

  /// Título principal de la pantalla del escáner de códigos de barras ISBN.
  ///
  /// In es, this message translates to:
  /// **'Escanear Código ISBN'**
  String get scanIsbnTitle;

  /// Texto con instrucciones para orientar al usuario al encuadrar el código de barras en la cámara.
  ///
  /// In es, this message translates to:
  /// **'Alinea el código de barras aquí'**
  String get scanIsbnInstruction;

  /// Mensaje de carga desplegado mientras se realiza la consulta del libro en la API.
  ///
  /// In es, this message translates to:
  /// **'Buscando libro por ISBN...'**
  String get scanIsbnLoading;

  /// Mensaje de alerta o título cuando una búsqueda por ISBN o escaneo no arroja resultados.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el libro'**
  String get bookNotFoundTitle;

  /// Pregunta de sugerencia o mensaje para permitir al usuario realizar una búsqueda por título/autor.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas buscarlo por nombre?'**
  String get searchByNamePrompt;

  /// Título del diálogo que advierte que un libro ya se encuentra en la biblioteca.
  ///
  /// In es, this message translates to:
  /// **'Libro Duplicado'**
  String get duplicateBookTitle;

  /// Mensajes explicativo que informa al usuario que el ISBN ingresado ya está registrado.
  ///
  /// In es, this message translates to:
  /// **'Ya existe este libro en tu biblioteca.'**
  String get duplicateBookMessage;

  /// Texto del botón para agregar una nota rápida
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get addNote;

  /// Título de la sección desplegable de notas
  ///
  /// In es, this message translates to:
  /// **'Notas de Lectura'**
  String get readingNotes;

  /// Mensaje cuando no se han creado notas en el libro
  ///
  /// In es, this message translates to:
  /// **'No hay notas registradas en este libro.'**
  String get noNotesRegistered;

  /// Título del modal para agregar nota
  ///
  /// In es, this message translates to:
  /// **'Nueva Nota de Lectura'**
  String get newReadingNote;

  /// Placeholder dentro del campo de texto de nota
  ///
  /// In es, this message translates to:
  /// **'Escribe tu reflexión o cita del libro...'**
  String get addNoteHint;

  /// Botón para desplegar la lista de notas dentro de la vista de lectura.
  ///
  /// In es, this message translates to:
  /// **'Ver notas'**
  String get viewNotes;

  /// Texto del botón cuando la lista de notas ya está visible.
  ///
  /// In es, this message translates to:
  /// **'Ocultar notas'**
  String get hideNotes;

  /// Mensaje informativo en caso de que el libro no posea notas registradas.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes notas registradas para este libro.'**
  String get noNotesYet;

  /// Título principal del modal para crear una nueva nota.
  ///
  /// In es, this message translates to:
  /// **'Agregar Nota'**
  String get addNoteTitle;

  /// Etiqueta para la sección de selección de categoría.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoryLabel;

  /// Categoría para citas textuales.
  ///
  /// In es, this message translates to:
  /// **'Cita'**
  String get categoryQuote;

  /// Categoría para resúmenes.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get categorySummary;

  /// Categoría para preguntas o dudas.
  ///
  /// In es, this message translates to:
  /// **'Pregunta'**
  String get categoryQuestion;

  /// Categoría para reflexiones personales.
  ///
  /// In es, this message translates to:
  /// **'Reflexión'**
  String get categoryReflection;

  /// Categoría para ideas o chispas de pensamiento.
  ///
  /// In es, this message translates to:
  /// **'Idea'**
  String get categoryIdea;

  /// Categoría general.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get categoryOther;

  /// Etiqueta para el campo de fecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// Etiqueta para el campo de página.
  ///
  /// In es, this message translates to:
  /// **'Página'**
  String get pageLabel;

  /// Opción desplegable para indicar el número de página.
  ///
  /// In es, this message translates to:
  /// **'Pág. {page}'**
  String pageOption(int page);

  /// Etiqueta para el campo de texto de la nota.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get noteLabel;

  /// Texto de sugerencia en el cuadro de texto de la nota.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu cita, resumen o reflexión...'**
  String get noteInputHint;

  /// Botón para confirmar y guardar la nota.
  ///
  /// In es, this message translates to:
  /// **'Guardar Nota'**
  String get saveNoteButton;

  /// Mensaje de error cuando el campo de página está vacío o no es un número.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una página válida'**
  String get errorEmptyPage;

  /// Mensaje de error cuando la página supera el total del libro.
  ///
  /// In es, this message translates to:
  /// **'La página no puede ser mayor a {totalPages}'**
  String errorInvalidPageRange(int totalPages);

  /// Mensaje de error cuando el cuadro de texto de la nota está vacío.
  ///
  /// In es, this message translates to:
  /// **'Escribe un contenido para la nota'**
  String get errorEmptyNote;

  /// Título de la sección o vista de notas asociadas a un libro.
  ///
  /// In es, this message translates to:
  /// **'Notas del libro'**
  String get bookNotesTitle;

  /// Mensaje de error cuando falla la carga del listado de notas.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar las notas: {error}'**
  String errorLoadingNotes(String error);

  /// Mensaje en estado vacío indicando que el libro no posee notas registradas.
  ///
  /// In es, this message translates to:
  /// **'No hay notas guardadas para este libro'**
  String get emptyNotesMessage;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil de lector'**
  String get profileTitle;

  /// No description provided for @defaultUserName.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get defaultUserName;

  /// No description provided for @readerLevelDefault.
  ///
  /// In es, this message translates to:
  /// **'Lector Voraz'**
  String get readerLevelDefault;

  /// Etiqueta para la pestaña Home en la barra de navegación principal.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// Etiqueta para la pestaña Biblioteca en la barra de navegación principal.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get navLibrary;

  /// Etiqueta para la pestaña Racha y Gráficos en la barra de navegación principal.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get navStats;

  /// Etiqueta para la pestaña Perfil en la barra de navegación principal.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// Título principal en el AppBar de la pantalla de detalles del libro
  ///
  /// In es, this message translates to:
  /// **'Tu libro'**
  String get yourBookTitle;

  /// Etiqueta para el código ISBN del libro
  ///
  /// In es, this message translates to:
  /// **'ISBN'**
  String get isbn;

  /// Texto para el botón o acción de eliminar
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get deleteAction;

  /// Título de la tarjeta de información de la editorial/edición
  ///
  /// In es, this message translates to:
  /// **'Información de Edición'**
  String get editionInfo;

  /// Etiqueta para la editorial del libro
  ///
  /// In es, this message translates to:
  /// **'Editorial'**
  String get publisher;

  /// Etiqueta para el idioma del libro
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Etiqueta para la fecha de publicación del libro
  ///
  /// In es, this message translates to:
  /// **'Publicación'**
  String get publicationDate;

  /// Título de la sección de sinopsis o descripción
  ///
  /// In es, this message translates to:
  /// **'Sinopsis'**
  String get synopsis;

  /// Título del menú desplegable de selección de estado
  ///
  /// In es, this message translates to:
  /// **'Estado de Lectura'**
  String get readingStatusTitle;

  /// Mensaje instructivo del menú de estados
  ///
  /// In es, this message translates to:
  /// **'Selecciona el estado actual de este libro'**
  String get readingStatusMessage;

  /// Estado: Leyendo
  ///
  /// In es, this message translates to:
  /// **'Leyendo'**
  String get statusReading;

  /// Estado: Por leer
  ///
  /// In es, this message translates to:
  /// **'Por leer'**
  String get statusToRead;

  /// Estado: Pausado
  ///
  /// In es, this message translates to:
  /// **'Pausado'**
  String get statusPaused;

  /// Estado: Abandonado
  ///
  /// In es, this message translates to:
  /// **'Abandonado'**
  String get statusDropped;

  /// Estado: Terminado
  ///
  /// In es, this message translates to:
  /// **'Terminado'**
  String get statusFinished;

  /// Título de la ventana modal de confirmación de borrado
  ///
  /// In es, this message translates to:
  /// **'Eliminar libro'**
  String get deleteBookDialogTitle;

  /// Mensaje de confirmación para eliminar un libro especificando su título
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar \"{bookTitle}\"? Esta acción no se puede deshacer.'**
  String deleteBookDialogMessage(String bookTitle);

  /// Mensaje de confirmación cuando un libro se añade a la lista de favoritos.
  ///
  /// In es, this message translates to:
  /// **'Agregado a favoritos'**
  String get addedToFavorites;

  /// Mensaje de confirmación cuando un libro se elimina de la lista de favoritos.
  ///
  /// In es, this message translates to:
  /// **'Quitado de favoritos'**
  String get removedFromFavorites;

  /// Mensaje de confirmación tras cambiar el estado de lectura de un libro (ej. Por leer, Leyendo, Terminado).
  ///
  /// In es, this message translates to:
  /// **'Estado del libro actualizado'**
  String get bookStatusUpdated;

  /// Texto para expandir un texto largo de conclusiones
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get showMore;

  /// Texto para retraer un texto largo de conclusiones
  ///
  /// In es, this message translates to:
  /// **'Ver menos'**
  String get showLess;

  /// Título principal para la tarjeta de estadísticas en el HomeScreen
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get statsTitle;

  /// Texto descriptivo o llamado a la acción secundario en la tarjeta de estadísticas
  ///
  /// In es, this message translates to:
  /// **'Mira aquí tus estadísticas'**
  String get statsDescription;

  /// Título para el flujo de adición manual
  ///
  /// In es, this message translates to:
  /// **'Agregar libro'**
  String get addManualBook;

  /// Título del AppBar en el detalle del libro para agregar
  ///
  /// In es, this message translates to:
  /// **'Agregar libro'**
  String get addBookTitle;

  /// Encabezado de la sección de datos generales
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get sectionInfo;

  /// Encabezado de la sección para seleccionar el estado de lectura del libro
  ///
  /// In es, this message translates to:
  /// **'Seleccione el estado de lectura'**
  String get sectionSelected;

  /// Encabezado de la sección de sinopsis o resumen
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get sectionDescription;

  /// Encabezado de la sección de datos de publicación
  ///
  /// In es, this message translates to:
  /// **'Editorial'**
  String get sectionPublisher;

  /// Encabezado para información complementaria como categorías o tags
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get sectionOther;

  /// Etiqueta para el campo de título
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get fieldTitle;

  /// Etiqueta para el campo de autores
  ///
  /// In es, this message translates to:
  /// **'Autor(es)'**
  String get fieldAuthors;

  /// Etiqueta para el código ISBN
  ///
  /// In es, this message translates to:
  /// **'ISBN'**
  String get fieldIsbn;

  /// Etiqueta para el idioma del libro
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get fieldLanguage;

  /// Etiqueta para la cantidad de páginas
  ///
  /// In es, this message translates to:
  /// **'Páginas'**
  String get fieldPages;

  /// Etiqueta para el nombre de la editorial
  ///
  /// In es, this message translates to:
  /// **'Editorial'**
  String get fieldPublisher;

  /// Etiqueta para la fecha de lanzamiento
  ///
  /// In es, this message translates to:
  /// **'Fecha de publicación'**
  String get fieldPublishedDate;

  /// Etiqueta para géneros o categorías
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get fieldCategories;

  /// Etiqueta para la calificación o puntaje del libro
  ///
  /// In es, this message translates to:
  /// **'Valoración'**
  String get fieldRating;

  /// Texto del botón principal para guardar la entidad en la base de datos
  ///
  /// In es, this message translates to:
  /// **'Guardar en la biblioteca'**
  String get btnSaveToLibrary;

  /// Título de la pantalla o modal para la búsqueda de portadas de libros.
  ///
  /// In es, this message translates to:
  /// **'Buscar imagen'**
  String get searchImageTitle;

  /// Texto placeholder del campo de texto de búsqueda.
  ///
  /// In es, this message translates to:
  /// **'Escribe para buscar imágenes en la red'**
  String get searchImageHint;

  /// Mensaje de error que se muestra cuando el campo de título del libro está vacío.
  ///
  /// In es, this message translates to:
  /// **'El título es requerido'**
  String get validationTitleRequired;

  /// Título del cuadro de diálogo de confirmación para reemplazar la portada.
  ///
  /// In es, this message translates to:
  /// **'Cambiar portada'**
  String get confirmChangeCoverTitle;

  /// Mensaje principal del cuadro de diálogo de confirmación.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas reemplazar la portada actual por esta imagen?'**
  String get confirmChangeCoverMessage;

  /// Mensaje de error cuando el usuario no ingresa el total de páginas al crear/editar un libro
  ///
  /// In es, this message translates to:
  /// **'El número total de páginas es obligatorio'**
  String get validationTotalPagesRequired;

  /// Mensaje de error cuando el total de páginas es menor o igual a cero
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número de páginas válido mayor a 0'**
  String get validationTotalPagesInvalid;

  /// Texto del botón para iniciar una nueva sesión de lectura
  ///
  /// In es, this message translates to:
  /// **'Leer'**
  String get newSession;

  /// Título de la sección desplegable del historial de sesiones
  ///
  /// In es, this message translates to:
  /// **'Historial de Lectura'**
  String get readingHistory;

  /// Mensaje cuando no hay sesiones grabadas
  ///
  /// In es, this message translates to:
  /// **'Aún no has registrado sesiones de lectura.'**
  String get noSessionsRegistered;

  /// Texto del rango de páginas leídas en una sesión
  ///
  /// In es, this message translates to:
  /// **'Páginas {startPage} a {endPage}'**
  String pagesRange(int startPage, int endPage);

  /// Texto para indicar la página final cuando no hay página de inicio registrada
  ///
  /// In es, this message translates to:
  /// **'Hasta página {endPage}'**
  String upToPage(int endPage);

  /// Título principal de la vista o modal de la sesión de lectura activa.
  ///
  /// In es, this message translates to:
  /// **'Sesión de Lectura'**
  String get readingSessionTitle;

  /// Etiqueta del botón para comenzar el conteo del cronómetro de lectura por primera vez.
  ///
  /// In es, this message translates to:
  /// **'Iniciar'**
  String get timerStart;

  /// Etiqueta del botón para reanudar el conteo del cronómetro tras haber sido pausado.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get timerResume;

  /// Etiqueta del botón para detener temporalmente el cronómetro de lectura.
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get timerPause;

  /// Botón principal para detener el cronómetro y registrar el avance de lectura.
  ///
  /// In es, this message translates to:
  /// **'Finalizar'**
  String get finishSession;

  /// Título principal del modal al finalizar una sesión de lectura.
  ///
  /// In es, this message translates to:
  /// **'Finalizar lectura'**
  String get finishReadingTitle;

  /// Etiqueta para mostrar la duración total de la sesión.
  ///
  /// In es, this message translates to:
  /// **'Tiempo leído'**
  String get timeReadLabel;

  /// Abreviatura de minutos.
  ///
  /// In es, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// Abreviatura de segundos.
  ///
  /// In es, this message translates to:
  /// **'s'**
  String get secondsShort;

  /// Etiqueta del campo donde el usuario ingresa la página alcanzada.
  ///
  /// In es, this message translates to:
  /// **'¿En qué página te quedaste?'**
  String get whatPageDidYouReach;

  /// Texto de sugerencia en el campo de texto de página actual.
  ///
  /// In es, this message translates to:
  /// **'Página actual ({page}/{lastPage})'**
  String currentPageHint(int page, int lastPage);

  /// Texto del botón principal para guardar el registro de lectura.
  ///
  /// In es, this message translates to:
  /// **'Guardar sesión'**
  String get saveSessionButton;

  /// Mensaje de error cuando el campo de página está vacío.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la página final'**
  String get validationEnterEndPage;

  /// Mensaje de error cuando el valor ingresado no es un entero válido.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número válido'**
  String get validationInvalidNumber;

  /// Mensaje de error cuando la página final es menor a la página donde se inició.
  ///
  /// In es, this message translates to:
  /// **'No puede ser menor a la página anterior ({currentPage})'**
  String validationPageLowerThanCurrent(int currentPage);

  /// Mensaje de error cuando la página ingresada excede las páginas totales del libro.
  ///
  /// In es, this message translates to:
  /// **'No puede superar el total de páginas ({totalPages})'**
  String validationPageExceedsTotal(int totalPages);

  /// Título superior de la pantalla de resumen.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get sessionSummaryTitle;

  /// Etiqueta para la cantidad de páginas leídas en la sesión.
  ///
  /// In es, this message translates to:
  /// **'Páginas leídas'**
  String get pagesReadLabel;

  /// Etiqueta para la velocidad en páginas por minuto.
  ///
  /// In es, this message translates to:
  /// **'Velocidad de lectura'**
  String get readingSpeedLabel;

  /// Formato para la velocidad de lectura.
  ///
  /// In es, this message translates to:
  /// **'{speed} pág/min'**
  String pagesPerMinute(String speed);

  /// Etiqueta para la estimación de tiempo para terminar el libro.
  ///
  /// In es, this message translates to:
  /// **'Tiempo restante est.'**
  String get estimatedTimeRemaining;

  /// Botón principal para guardar y volver al inicio.
  ///
  /// In es, this message translates to:
  /// **'Finalizar'**
  String get doneButton;

  /// Título principal de la vista de resumen al terminar de leer.
  ///
  /// In es, this message translates to:
  /// **'Resultado de la sesión de lectura'**
  String get sessionResultTitle;

  /// Informa cuántas páginas leyó el usuario y la duración de la sesión.
  ///
  /// In es, this message translates to:
  /// **'Has leído {pages} páginas durante {duration}.'**
  String readSummaryInfo(int pages, String duration);

  /// Muestra el promedio de velocidad de lectura por hora.
  ///
  /// In es, this message translates to:
  /// **'Esta es la velocidad promedio a la que lees: {pagesPerHour} páginas por hora.'**
  String readingSpeedInfo(String pagesPerHour);

  /// Muestra la estimación del tiempo restante para terminar el libro.
  ///
  /// In es, this message translates to:
  /// **'El tiempo para finalizar es {timeRemaining}.'**
  String timeRemainingInfo(String timeRemaining);

  /// Indica cuántas páginas le faltan al usuario para concluir el libro.
  ///
  /// In es, this message translates to:
  /// **'Quedan {pagesRemaining} páginas para terminar tu libro.'**
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
