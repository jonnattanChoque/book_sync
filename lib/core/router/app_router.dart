import 'package:book_sync/src/features/reader_session/presentation/summary_screen.dart';
import 'package:book_sync/src/features/streak/presentation/screens/streak_screen.dart';
import 'package:flutter/material.dart';
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

// Claves globales para controlar la navegación por ramas
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
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
              builder: (context, state) => const HomeScreen(),
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
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Racha y Gráficos')),
              ),
            ),
          ],
        ),

        // Rama 3: Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Perfil')),
              ),
            ),
          ],
        ),
      ],
    ),

    // --- RUTAS MODALES / PANTALLAS COMPLETAS (Fuera del Shell o navegables por encima) ---
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
    )
  ],
);