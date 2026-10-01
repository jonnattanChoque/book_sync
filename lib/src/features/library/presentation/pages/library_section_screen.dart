import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/utils/book_serted_helper.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/library/presentation/widgets/library_card_item.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibrarySectionScreen extends ConsumerStatefulWidget {
  const LibrarySectionScreen({super.key});

  @override
  ConsumerState<LibrarySectionScreen> createState() => _LibrarySectionScreenState();
}

class _LibrarySectionScreenState extends ConsumerState<LibrarySectionScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final allBooksAsync = ref.watch(allBooksProvider);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPaperTexture(),
          _buildLibraryContent(context, allBooksAsync),
        ],
      ),
    );
  }

  Widget _buildLibraryContent(BuildContext context, AsyncValue<List<Book>> allBooksAsync) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              AppIcons.back,
              color: context.theme.colorScheme.onSurface,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          title: Text(context.l10n.libraryTitle, style: context.theme.textTheme.titleLarge),
          bottom: _LibraryHeaderBottom(
            tabBar: TabBar(
              tabAlignment: TabAlignment.fill,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelColor: context.cozy.bookmarkColor!,
              unselectedLabelColor: context.cozy.inkColor!.withValues(alpha: 0.5),
              indicatorColor: context.cozy.bookmarkColor!.withValues(alpha: 1),
              tabs: [
                Tab(text: context.l10n.tabLibraryReading),
                Tab(text: context.l10n.tabLibraryToRead), 
                Tab(text: context.l10n.tabLibraryRead),
                Tab(text: context.l10n.tabLibraryDropped),
              ],
            ),
            isFavoritesOnly: _showOnlyFavorites,
            onFavoritesToggled: () {
              setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
              });
            },
          ),
        ),
        body: allBooksAsync.when(
          data: (books) {
            final bookSorted = sortBooksByLastAdded(books);

            if (_showOnlyFavorites) {
              final favoriteBooks = bookSorted.where((b) => b.isFavorite == true).toList();
              return _BookListSection(
                books: favoriteBooks,
                emptyMessage: context.l10n.noSearchResults,
              );
            }

            final readingBooks = bookSorted.where((b) => b.status == BookStatus.reading).toList();
            final toReadBooks = bookSorted.where((b) => b.status == BookStatus.toRead).toList();
            final finishedBooks = bookSorted.where((b) => b.status == BookStatus.finished).toList();
            final forgottenBooks = bookSorted.where((b) => b.status == BookStatus.dropped).toList();

            return TabBarView(
              children: [
                _BookListSection(books: readingBooks, emptyMessage: context.l10n.emptyReading),
                _BookListSection(books: toReadBooks, emptyMessage: context.l10n.emptyToRead),
                _BookListSection(books: finishedBooks, emptyMessage: context.l10n.emptyFinished),
                _BookListSection(books: forgottenBooks, emptyMessage: context.l10n.emptyDropped),
              ],
            );
          },
          loading: () => const Center(child: BookLoader()),
          error: (err, stack) => Center(
            child: Text(context.l10n.errorLoadLibrary),
          ),
        ),
      ),
    );
  }
}

/// Header inferior que combina el TabBar y la barra del filtro de Favoritos
class _LibraryHeaderBottom extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  final bool isFavoritesOnly;
  final VoidCallback onFavoritesToggled;

  const _LibraryHeaderBottom({
    required this.tabBar,
    required this.isFavoritesOnly,
    required this.onFavoritesToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFavoritesButton(context),
        tabBar
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tabBar.preferredSize.height + 44);

  Padding _buildFavoritesButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        child: FilterChip(
          selected: isFavoritesOnly,
          label: Text(
            context.l10n.favoritesFilterLabel,
            style: TextStyle(
              fontSize: 12,
              color: isFavoritesOnly 
                ? Colors.red.shade700 
                : context.cozy.inkColor?.withValues(alpha: 0.8),
            ),
          ),
          avatar: Icon(
            isFavoritesOnly ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            size: 16,
            color: isFavoritesOnly ? Colors.red : context.cozy.inkColor?.withValues(alpha: 0.6),
          ),
          onSelected: (_) => onFavoritesToggled(),
          backgroundColor: Colors.transparent,
          selectedColor: Colors.red.withValues(alpha: 0.15),
          checkmarkColor: Colors.red,
          side: BorderSide(
            color: isFavoritesOnly 
                ? Colors.red.withValues(alpha: 0.4) 
                : context.cozy.bookmarkColor!.withValues(alpha: 0.2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          visualDensity: VisualDensity.compact,
        ),
      );
  }
}

// Widget auxiliar para listar los libros de cada sección
class _BookListSection extends StatelessWidget {
  final List<dynamic> books;
  final String emptyMessage;

  const _BookListSection({required this.books, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: context.theme.textTheme.labelLarge,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final bool isFinished = book.status == BookStatus.finished || book.progress >= 1.0;
          return LibraryCardItem(book: book, isFinished: isFinished);          
        },
      ),
    );
  }
}