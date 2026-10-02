import 'package:book_sync/core/data/datasources/app_config_datasource.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/router/app_router.dart';
import 'package:book_sync/core/services/notification_service.dart';
import 'package:book_sync/core/theme/app_theme.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/domain/user_streak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es', null);
  await initializeDateFormatting('en', null);
  
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      AppConfigSchema,
      BookSchema,
      NoteSchema,
      ReadingSessionSchema,
      UserStreakSchema
    ],
    directory: dir.path,
  );

  final datasource = AppConfigDatasource(isar);
  final initialSettings = await datasource.getOrInitSettings();

  await NotificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        appSettingsProvider.overrideWith(
          (ref) => AppSettingsNotifier(initialSettings, datasource),
        ),
      ],
      child: const ToastificationWrapper(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Book Sync',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.locale,
    );
  }
}