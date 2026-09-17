import 'package:book_sync/core/router/page_turn_transition.dart';
import 'package:book_sync/src/features/home/presentation/home_screen.dart';
import 'package:book_sync/src/features/library/presentation/pages/library_section_view.dart';
import 'package:book_sync/src/features/main_wrapper.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:book_sync/src/features/search/presentation/search_detail.dart';
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
            final book = state.extra as BookSearchDto;
            return CustomTransitionPage(
              key: state.pageKey,
              child: BookDetailScreen(book: book),
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
              child: const LibrarySectionsView(),
              transitionsBuilder: buildPageTurnTransition,
              transitionDuration: const Duration(milliseconds: 900),
              reverseTransitionDuration: const Duration(milliseconds: 700),
            );
          },
        ),
      ],
    ),
  ],
);