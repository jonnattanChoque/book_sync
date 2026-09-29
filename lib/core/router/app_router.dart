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
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
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
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: SearchScannerScreen(),
              transitionsBuilder: buildPageTurnTransition,
              transitionDuration: const Duration(milliseconds: 900),
              reverseTransitionDuration: const Duration(milliseconds: 700),
            );
          },
        ),
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
        GoRoute(
          path: '/book_detail',
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
      ],
    ),
  ],
);