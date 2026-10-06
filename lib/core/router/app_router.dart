// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:book_sync/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:book_sync/src/features/auth/presentation/screens/auth_screen.dart';
import 'package:book_sync/src/features/auth/presentation/screens/premium_paywall_screen.dart';
import 'package:book_sync/src/features/calendar_export/presentation/screens/reading_calendar_screen.dart';
import 'package:book_sync/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:book_sync/src/features/reader_session/presentation/summary_screen.dart';
import 'package:book_sync/src/features/stats/presentation/screens/stats_screen.dart';
import 'package:book_sync/src/features/streak/presentation/screens/streak_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:book_sync/core/router/page_turn_transition.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/home/presentation/home_screen.dart';
import 'package:book_sync/src/features/library/presentation/pages/library_section_screen.dart';
import 'package:book_sync/src/features/main_wrapper.dart';
import 'package:book_sync/src/features/reader_session/presentation/book_detail_screen.dart';
import 'package:book_sync/src/features/reader_session/presentation/reading_session_screen.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:book_sync/src/features/search/presentation/search_detail_screen.dart';
import 'package:book_sync/src/features/search/presentation/search_image_screen.dart';
import 'package:book_sync/src/features/search/presentation/search_isbn_screen.dart';
import 'package:book_sync/src/features/search/presentation/search_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(
      authStateChangesProvider,
      (_, _) => notifyListeners(), // Notifica a GoRouter para ejecutar redirect
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggingIn = state.matchedLocation == '/auth';

      // Si el usuario tiene sesión activa y está en /login, redirigir a /home
      if (session != null && loggingIn) {
        return '/';
      }

      // Si el usuario no tiene sesión y no está en /login, enviarlo a /login
      if (session == null && !loggingIn) {
        return '/auth';
      }

      return null;
    },
    routes: [
      // Shell persistente con mantenimiento de estado para el BottomNavBar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Rama 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const HomeScreen(),
                    transitionsBuilder: buildPageTurnTransition,
                    transitionDuration: const Duration(milliseconds: 900),
                    reverseTransitionDuration: const Duration(milliseconds: 700),
                  );
                },
              ),
            ],
          ),

          // Rama 1: Biblioteca
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const LibrarySectionScreen(),
                    transitionsBuilder: buildPageTurnTransition,
                    transitionDuration: const Duration(milliseconds: 900),
                    reverseTransitionDuration: const Duration(milliseconds: 700),
                  );
                },
              ),
            ],
          ),

          // Rama 2: Racha y Gráficos
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const StatsScreen(),
                    transitionsBuilder: buildPageTurnTransition,
                    transitionDuration: const Duration(milliseconds: 900),
                    reverseTransitionDuration: const Duration(milliseconds: 700),
                  );
                },
              ),
            ],
          ),

          // Rama 3: Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const ProfileScreen(),
                    transitionsBuilder: buildPageTurnTransition,
                    transitionDuration: const Duration(milliseconds: 900),
                    reverseTransitionDuration: const Duration(milliseconds: 700),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // --- RUTAS MODALES / PANTALLAS COMPLETAS (Fuera del Shell o navegables por encima) ---
      GoRoute(
        path: '/auth',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AuthScreen(),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 700),
          );
        },
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SearchScreen(),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 700),
          );
        },
      ),
      GoRoute(
        path: '/search_detail',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final book = state.extra as BookSearchDto?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BookSearchDetailScreen(book: book),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 700),
          );
        },
      ),
      GoRoute(
        path: '/search_image',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final initialQuery = state.extra as String?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SearchImageScreen(initialQuery: initialQuery),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 700),
          );
        },
      ),
      GoRoute(
        path: '/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SearchScannerScreen(),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 700),
          );
        },
      ),
      GoRoute(
        path: '/book_detail',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final book = state.extra as Book;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BookDetailScreen(book: book),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: '/reading_session',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final book = state.extra as Book;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ReadingSessionScreen(book: book),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: '/summary',
        pageBuilder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final book = extraData?['book'] as Book;
          final session = extraData?['session'] as ReadingSession;
          
          return CustomTransitionPage(
            key: state.pageKey,
            child: SessionSummaryPage(book: book, session: session),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: '/streak',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: StreakScreen(),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: '/calendar',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ReadingCalendarScreen(),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: '/premium',
        pageBuilder: (context, state) {
          final title = state.extra as String;
          return CustomTransitionPage(
            key: state.pageKey,
            child: PremiumPaywallScreen(contentText: title),
            transitionsBuilder: buildPageTurnTransition,
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 500),
          );
        },
      )
    ]
  );
});
