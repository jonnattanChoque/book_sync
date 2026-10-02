import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _readingReminderId = 1001; // ID fijo para el recordatorio de lectura

  /// Inicializa el servicio de notificaciones y zonas horarias
  static Future<void> init() async {
    tz.initializeTimeZones();

    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // ESTAS LÍNEAS PERMITEN MOSTRAR BANNERS Y SONIDO CON LA APP ABIERTA:
      notificationCategories: [],
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Lógica al tocar la notificación si la app está cerrada/abierta
      },
    );
  }

  /// Programa o actualiza la alarma diaria de lectura
  static Future<void> scheduleDailyReadingReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelName,        // <--- Parámetro dinámico
    required String channelDescription, // <--- Parámetro dinámico
  }) async {
    // 1. Cancelamos cualquier alarma previa
    await cancelReadingReminder();

    // 2. Calculamos el próximo momento en el que debe sonar
    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

    // 3. Configuración del canal para Android con los textos localizados
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reading_reminder_channel',
      channelName, // <--- Usamos la variable traducida
      channelDescription: channelDescription, // <--- Usamos la variable traducida
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // 4. Programar notificación diaria
    await _notificationsPlugin.zonedSchedule(
      _readingReminderId,
      title,
      body,
      scheduledDate,
      platformDetails,
      // Usa exactAllowWhileIdle para asegurar que suene aun con el teléfono en reposo/ahorro de batería
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Solicita permisos de notificación en tiempo de ejecución (iOS y Android)
  static Future<bool> requestPermissions() async {
    // 1. Solicitar en Android
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    final bool? androidGranted = await androidImplementation?.requestNotificationsPermission();
    final bool? exactAlarmGranted = await androidImplementation?.requestExactAlarmsPermission();

    // 2. Solicitar en iOS
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    final bool? iosGranted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return (androidGranted ?? iosGranted ?? exactAlarmGranted ?? false);
  }

  /// Cancela el recordatorio diario de lectura
  static Future<void> cancelReadingReminder() async {
    await _notificationsPlugin.cancel(_readingReminderId);
  }

  /// Calcula la próxima ocurrencia exacta de la hora configurada
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // Si la hora de hoy ya pasó, la programamos para el día siguiente
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

}