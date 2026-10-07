import 'package:book_sync/core/data/datasources/app_config_datasource.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/providers/preferences_provider.dart';
import 'package:book_sync/core/router/app_router.dart';
import 'package:book_sync/core/services/app_bootstrap_service.dart';
import 'package:book_sync/core/services/preferences_service.dart';
import 'package:book_sync/core/services/subscription_service.dart';
import 'package:book_sync/core/theme/app_theme.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/domain/user_streak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uyjsxynxlynvzumycsxp.supabase.co',
    publishableKey: 'sb_publishable_TfJXryTwO4KOzI7LovdFJg_VV1ePkRl',
  );
  await SubscriptionService.initStore();
  final sharedPreferences = await SharedPreferences.getInstance();

  // 2. Inicializar Isar DB de forma segura
  final dir = await getApplicationDocumentsDirectory();
  Isar? isar = Isar.getInstance();
  if (isar == null || !isar.isOpen) {
    isar = await Isar.open(
      [
        AppConfigSchema,
        BookSchema,
        NoteSchema,
        ReadingSessionSchema,
        UserStreakSchema,
      ],
      directory: dir.path,
    );
  }
  final currentSession = Supabase.instance.client.auth.currentSession;
  final String? activeUserId = currentSession?.user.id;
  final datasource = AppConfigDatasource(isar);
  final userSettings = await datasource.getOrInitSettings(activeUserId);

  // 2. Creamos el contenedor ya con el override del appSettingsProvider listo
  final container = ProviderContainer(
    overrides: [
      isarProvider.overrideWithValue(isar),
      appSettingsProvider.overrideWith(
        (ref) => AppSettingsNotifier(userSettings, datasource),
      ),
      preferencesServiceProvider.overrideWith(
        (ref) => PreferencesService(sharedPreferences), // O la implementación real que uses para preferencias
      ),
    ],
  );

  // 3. Instanciamos el bootstrap service pasándole el contenedor y ejecutamos su init()
  final bootstrapService = AppBootstrapService(container, currentSession: currentSession, activeUserId: activeUserId, userSettings: userSettings, isar: isar, datasource: datasource);
  await bootstrapService.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
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
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Book Sync',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.locale,
    );
  }
}