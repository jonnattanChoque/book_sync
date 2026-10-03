// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => 'Hola,';

  @override
  String get welcomeMessage => 'Lector de historias';

  @override
  String get userName => 'Lector de Historias';

  @override
  String get addBook => 'Agregar libro';

  @override
  String get currentlyReading => 'Leyendo ahora';

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
  String get cameraAccessError => 'Error al acceder a la cámara';

  @override
  String get retry => 'Reintentar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String errorLoadingBooks(String error) {
    return 'Error al cargar libros: $error';
  }

  @override
  String get ratingRequiredMessage =>
      'Por favor, ingresa tu valoración del libro para finalizar.';

  @override
  String get congratulationsFinishedTitle => '¡Felicidades por terminarlo!';

  @override
  String get conclusionsHint => 'Escribe tus conclusiones o reseña final...';

  @override
  String get saveAndFinishButton => 'Guardar y Concluir';

  @override
  String get skipRatingButton => 'No valorar por ahora';

  @override
  String get rateThisBookAction => 'Valorar este libro';

  @override
  String get streakIncreased => '¡Racha Aumentada!';

  @override
  String get streakCurrent => 'Racha Actual';

  @override
  String get streakTitle => 'Racha de lectura';

  @override
  String bestStreakLabel(Object count) {
    return 'Mejor racha: $count días';
  }

  @override
  String get currentStreakTitle => 'Racha actual';

  @override
  String get bestStreakTitle => 'Mejor racha';

  @override
  String streakDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String streakDateRange(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get noActiveStreak => 'Sin racha activa';

  @override
  String get readingCalendarTitle => 'Calendario de lectura';

  @override
  String booksReadOnDate(Object count) {
    return 'Lecturas del día ($count)';
  }

  @override
  String get noReadingOnDate => 'No registraste lecturas este día';

  @override
  String pagesReadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas leídas',
      one: '1 página leída',
    );
    return '$_temp0';
  }

  @override
  String readingDayText(int days) {
    return 'Día $days';
  }

  @override
  String progressLabel(String percentage) {
    return '$percentage% completado';
  }

  @override
  String startDateWith(String date) {
    return 'Inicio: $date';
  }

  @override
  String remainingTime(String time) {
    return 'Restante: $time';
  }

  @override
  String pageProgress(int currentPage, int totalPages) {
    return 'Pág. $currentPage / $totalPages';
  }

  @override
  String currentPageFormat(int currentPage) {
    return 'Pág. $currentPage';
  }

  @override
  String get progressInfo => 'Información de progreso';

  @override
  String get startDate => 'Inicio';

  @override
  String get day => 'Día';

  @override
  String get remaining => 'Restante';

  @override
  String get progress => 'Progreso';

  @override
  String get pagesAbbr => 'págs';

  @override
  String get pageAbbr => 'Pág';

  @override
  String get minutesAbbr => 'min';

  @override
  String get libraryTitle => 'Mi Biblioteca';

  @override
  String get noBooksRegistered => 'No hay libros registrados';

  @override
  String libraryCount(int count) {
    return '$count Libros';
  }

  @override
  String libraryOneCount(int count) {
    return '$count Libro';
  }

  @override
  String get tabLibraryReading => 'Leyendo';

  @override
  String get tabLibraryToRead => 'Por leer';

  @override
  String get tabLibraryRead => 'Leídos';

  @override
  String get tabLibraryDropped => 'Abandonados';

  @override
  String get tabLibraryPaused => 'Pausados';

  @override
  String get emptyReading => 'No hay libros en lectura';

  @override
  String get emptyToRead => 'No hay libros por leer';

  @override
  String get emptyFinished => 'No hay libros leídos aún';

  @override
  String get emptyDropped => 'No hay libros abandonados aún';

  @override
  String get errorLoadLibrary => 'Error al cargar la biblioteca';

  @override
  String get favoritesFilterLabel => 'Todos tus favoritos';

  @override
  String get searchTitle => 'Buscar Libro';

  @override
  String get searchButton => 'Buscar';

  @override
  String get searchPlaceholder => 'Título o autor...';

  @override
  String get searchInitialHint => 'Escribe para buscar libros en la red';

  @override
  String get noSearchResults => 'No se encontraron resultados';

  @override
  String get scanIsbnTitle => 'Escanear Código ISBN';

  @override
  String get scanIsbnInstruction => 'Alinea el código de barras aquí';

  @override
  String get scanIsbnLoading => 'Buscando libro por ISBN...';

  @override
  String get bookNotFoundTitle => 'No se encontró el libro';

  @override
  String get searchByNamePrompt => '¿Deseas buscarlo por nombre?';

  @override
  String get duplicateBookTitle => 'Libro Duplicado';

  @override
  String get duplicateBookMessage => 'Ya existe este libro en tu biblioteca.';

  @override
  String get addNote => 'Nota';

  @override
  String get readingNotes => 'Notas de Lectura';

  @override
  String get noNotesRegistered => 'No hay notas registradas en este libro.';

  @override
  String get newReadingNote => 'Nueva Nota de Lectura';

  @override
  String get addNoteHint => 'Escribe tu reflexión o cita del libro...';

  @override
  String get viewNotes => 'Ver notas';

  @override
  String get hideNotes => 'Ocultar notas';

  @override
  String get noNotesYet => 'Aún no tienes notas registradas para este libro.';

  @override
  String get addNoteTitle => 'Agregar Nota';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get categoryQuote => 'Cita';

  @override
  String get categorySummary => 'Resumen';

  @override
  String get categoryQuestion => 'Pregunta';

  @override
  String get categoryReflection => 'Reflexión';

  @override
  String get categoryIdea => 'Idea';

  @override
  String get categoryOther => 'Otro';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get pageLabel => 'Página';

  @override
  String pageOption(int page) {
    return 'Pág. $page';
  }

  @override
  String get noteLabel => 'Nota';

  @override
  String get noteInputHint => 'Escribe tu cita, resumen o reflexión...';

  @override
  String get saveNoteButton => 'Guardar Nota';

  @override
  String get errorEmptyPage => 'Ingresa una página válida';

  @override
  String errorInvalidPageRange(int totalPages) {
    return 'La página no puede ser mayor a $totalPages';
  }

  @override
  String get errorEmptyNote => 'Escribe un contenido para la nota';

  @override
  String get bookNotesTitle => 'Notas del libro';

  @override
  String errorLoadingNotes(String error) {
    return 'Error al cargar las notas: $error';
  }

  @override
  String get emptyNotesMessage => 'No hay notas guardadas para este libro';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get userDataSection => 'Datos de Usuario';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get saveButton => 'Guardar cambios';

  @override
  String get settingsSection => 'Ajustes de la Aplicación';

  @override
  String get themeTitle => 'Tema de la aplicación';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageEs => 'Español';

  @override
  String get languageEn => 'Inglés';

  @override
  String get remindersSection => 'Recordatorios';

  @override
  String get readingAlarmTitle => 'Alarma para leer';

  @override
  String get readingAlarmSubtitle =>
      'Configura una notificación diaria para mantener tu racha';

  @override
  String get goalsSection => 'Objetivos de Lectura';

  @override
  String get dailyGoal => 'Objetivo diario (minutos)';

  @override
  String get weeklyGoal => 'Objetivo semanal (libros)';

  @override
  String get monthlyGoal => 'Objetivo mensual (libros)';

  @override
  String get yearlyGoal => 'Objetivo anual (libros)';

  @override
  String get weeklyHoursGoal => 'Objetivo semanal (horas)';

  @override
  String get goalsSaved => '¡Objetivos guardados!';

  @override
  String get notificationChannelName => 'Recordatorio de Lectura';

  @override
  String get notificationChannelDescription =>
      'Notificaciones diarias para recordar tu sesión de lectura';

  @override
  String get notificationTitle => '¡Hora de leer! 📚';

  @override
  String get notificationBody =>
      'Mantén tu racha diaria y avanza en tu meta de lectura.';

  @override
  String get notificationSaved => 'Alarma programada con éxito!';

  @override
  String imageSelectionError(String error) {
    return 'Error al seleccionar la imagen: $error';
  }

  @override
  String get chooseFromGallery => 'Elegir de la Galería';

  @override
  String get takePhotoWithCamera => 'Tomar Foto con Cámara';

  @override
  String get nameSavedSuccess => '¡Nombre guardado con éxito!';

  @override
  String get imageSavedSuccess => '¡Imagen guardada con éxito!';

  @override
  String get navHome => 'Inicio';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navProfile => 'Perfil';

  @override
  String get yourBookTitle => 'Tu libro';

  @override
  String get isbn => 'ISBN';

  @override
  String get deleteAction => 'Borrar';

  @override
  String get editionInfo => 'Información de Edición';

  @override
  String get publisher => 'Editorial';

  @override
  String get language => 'Idioma';

  @override
  String get publicationDate => 'Publicación';

  @override
  String get synopsis => 'Sinopsis';

  @override
  String get readingStatusTitle => 'Estado de Lectura';

  @override
  String get readingStatusMessage =>
      'Selecciona el estado actual de este libro';

  @override
  String get statusReading => 'Leyendo';

  @override
  String get statusToRead => 'Por leer';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get statusDropped => 'Abandonado';

  @override
  String get statusFinished => 'Terminado';

  @override
  String get deleteBookDialogTitle => 'Eliminar libro';

  @override
  String deleteBookDialogMessage(String bookTitle) {
    return '¿Estás seguro de que deseas eliminar \"$bookTitle\"? Esta acción no se puede deshacer.';
  }

  @override
  String get addedToFavorites => 'Agregado a favoritos';

  @override
  String get removedFromFavorites => 'Quitado de favoritos';

  @override
  String get bookStatusUpdated => 'Estado del libro actualizado';

  @override
  String get showMore => 'Ver más';

  @override
  String get showLess => 'Ver menos';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsDescription => 'Mira aquí tus estadísticas';

  @override
  String get statsYearlyGoalTitle => 'Objetivo Anual';

  @override
  String statsYearlyGoalSub(int read, int target) {
    return '$read de $target libros';
  }

  @override
  String get statsMonthlyBooksAvg => 'Promedio Libros/Mes';

  @override
  String get statsReadingSpeed => 'Velocidad de Lectura';

  @override
  String statsPagesPerHour(String pages) {
    return '$pages pág/h';
  }

  @override
  String get statsTotalYearlySummary => 'Total del Año';

  @override
  String statsTotalReadFormat(int hours, int minutes, int pages) {
    return '${hours}h ${minutes}m \n$pages págs';
  }

  @override
  String get statsBarChartTitle => 'Actividad de Lectura';

  @override
  String get statsFilterMonthly => 'Mes';

  @override
  String get statsFilterYearly => 'Año';

  @override
  String get statsPagesReadLabel => 'Páginas leídas';

  @override
  String get statsHoursReadLabel => 'Horas leídas';

  @override
  String get statsMonthlyBooksSubtitle => 'Libros leídos por mes este año';

  @override
  String get statsBookCountSingular => 'libro';

  @override
  String get statsBookCountPlural => 'libros';

  @override
  String get statsYearFilterTooltip => 'Seleccionar año';

  @override
  String get statsSelectYearTitle => 'Seleccionar Año';

  @override
  String get statsNoDataForYearTitle => 'Sin registros de lectura';

  @override
  String get statsNoDataForYearSubtitle => 'No terminaste libros en este año';

  @override
  String get statsReadingTimeChartTitle => 'Tiempo de lectura por mes';

  @override
  String get statsNoReadingTimeForYearTitle =>
      'Sin tiempo de lectura registrado';

  @override
  String statsPagesCount(int count) {
    return '$count págs';
  }

  @override
  String get statsRatingsChartTitle => 'Distribución por valoración';

  @override
  String get statsNoRatingsForYearTitle => 'Sin valoraciones en este año';

  @override
  String statsBooksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libros',
      one: '1 libro',
    );
    return '$_temp0';
  }

  @override
  String get statsCategoriesChartTitle => 'Distribución por categorías';

  @override
  String get statsNoCategoriesForYearTitle => 'Sin categorías en este año';

  @override
  String statsBooksInCategory(String category) {
    return 'Libros en $category:';
  }

  @override
  String get statsWeeklyHoursGoalTitle => 'Objetivo Semanal';

  @override
  String statsWeeklyHoursGoalSub(String hours, Object goals) {
    return '$hours horas de $goals';
  }

  @override
  String get statsTopGenresTitle => 'Top 3 Géneros';

  @override
  String get statsCurrentStreakTitle => 'Racha Actual';

  @override
  String get statsReadingRecordTitle => 'Récord de Lectura';

  @override
  String statsStreakDaysFormat(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días seguidos',
      one: '1 día seguido',
    );
    return '$_temp0';
  }

  @override
  String get statsNoData => 'Sin datos aún';

  @override
  String statsPagesReadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String get addManualBook => 'Agregar libro';

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

  @override
  String get searchImageTitle => 'Buscar imagen';

  @override
  String get searchImageHint => 'Escribe para buscar imágenes en la red';

  @override
  String get validationTitleRequired => 'El título es requerido';

  @override
  String get confirmChangeCoverTitle => 'Cambiar portada';

  @override
  String get confirmChangeCoverMessage =>
      '¿Deseas reemplazar la portada actual por esta imagen?';

  @override
  String get validationTotalPagesRequired =>
      'El número total de páginas es obligatorio';

  @override
  String get validationTotalPagesInvalid =>
      'Ingresa un número de páginas válido mayor a 0';

  @override
  String get newSession => 'Leer';

  @override
  String get readingHistory => 'Historial de Lectura';

  @override
  String get noSessionsRegistered =>
      'Aún no has registrado sesiones de lectura.';

  @override
  String pagesRange(int startPage, int endPage) {
    return 'Páginas $startPage a $endPage';
  }

  @override
  String upToPage(int endPage) {
    return 'Hasta página $endPage';
  }

  @override
  String get readingSessionTitle => 'Sesión de Lectura';

  @override
  String get timerStart => 'Iniciar';

  @override
  String get timerResume => 'Continuar';

  @override
  String get timerPause => 'Pausar';

  @override
  String get finishSession => 'Finalizar';

  @override
  String get finishReadingTitle => 'Finalizar lectura';

  @override
  String get timeReadLabel => 'Tiempo leído';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsShort => 's';

  @override
  String get whatPageDidYouReach => '¿En qué página te quedaste?';

  @override
  String currentPageHint(int page, int lastPage) {
    return 'Página actual ($page/$lastPage)';
  }

  @override
  String get saveSessionButton => 'Guardar sesión';

  @override
  String get validationEnterEndPage => 'Ingresa la página final';

  @override
  String get validationInvalidNumber => 'Ingresa un número válido';

  @override
  String validationPageLowerThanCurrent(int currentPage) {
    return 'No puede ser menor a la página anterior ($currentPage)';
  }

  @override
  String validationPageExceedsTotal(int totalPages) {
    return 'No puede superar el total de páginas ($totalPages)';
  }

  @override
  String get sessionSummaryTitle => 'Resumen';

  @override
  String get pagesReadLabel => 'Páginas leídas';

  @override
  String get readingSpeedLabel => 'Velocidad de lectura';

  @override
  String pagesPerMinute(String speed) {
    return '$speed pág/min';
  }

  @override
  String get estimatedTimeRemaining => 'Tiempo restante est.';

  @override
  String get doneButton => 'Finalizar';

  @override
  String get sessionResultTitle => 'Resultado de la sesión de lectura';

  @override
  String readSummaryInfo(int pages, String duration) {
    return 'Has leído $pages páginas durante $duration.';
  }

  @override
  String readingSpeedInfo(String pagesPerHour) {
    return 'Esta es la velocidad promedio a la que lees: $pagesPerHour páginas por hora.';
  }

  @override
  String timeRemainingInfo(String timeRemaining) {
    return 'El tiempo para finalizar es $timeRemaining.';
  }

  @override
  String pagesRemainingInfo(int pagesRemaining) {
    return 'Quedan $pagesRemaining páginas para terminar tu libro.';
  }
}
