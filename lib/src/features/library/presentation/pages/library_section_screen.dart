import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibrarySectionScreen extends ConsumerWidget {
  const LibrarySectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooksAsync = ref.watch(allBooksProvider);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPaperTexture(),
          _buildLibraryContent(context, allBooksAsync),
        ]
      )
    );
  }

  DefaultTabController _buildLibraryContent(BuildContext context, AsyncValue<List<Book>> allBooksAsync) {
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
          bottom: TabBar(
            labelColor: context.cozy.bookmarkColor!,
            unselectedLabelColor: context.cozy.inkColor!.withValues(alpha: 0.5),
            indicatorColor: context.cozy.bookmarkColor!.withValues(alpha: 1),
            tabs: [
              Tab(text: context.l10n.tabLibraryReading),
              Tab(text: context.l10n.tabLibraryToRead), 
              Tab(text: context.l10n.tabLibraryRead),
              Tab(text: context.l10n.tabLibraryDropped),
              Tab(text: context.l10n.tabLibraryPaused),
            ],
          ),
        ),
        body: allBooksAsync.when(
          data: (books) {
            final readingBooks = books.where((b) => b.status == BookStatus.reading).toList();
            final toReadBooks = books.where((b) => b.status == BookStatus.toRead).toList();
            final finishedBooks = books.where((b) => b.status == BookStatus.finished).toList();
            final forggotenBooks = books.where((b) => b.status == BookStatus.dropped).toList();
    
            return TabBarView(
              children: [
                _BookListSection(books: readingBooks, emptyMessage: context.l10n.emptyReading),
                _BookListSection(books: toReadBooks, emptyMessage: context.l10n.emptyToRead),
                _BookListSection(books: finishedBooks, emptyMessage: context.l10n.emptyFinished),
                _BookListSection(books: forggotenBooks, emptyMessage: context.l10n.emptyDropped),
              ],
            );
          },
          loading: () => const Center(child: BookLoader()),
          error: (err, stack) => Center(
            child: Text("Error al cargar la biblioteca: $err"),
          ),
        ),
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
          style: context.theme.textTheme.labelLarge
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
          return Card(
            color: context.theme.cardColor.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                context.push('/book_detail', extra: book);
              },
              child: ListTile(
                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(book.author),
                trailing: Text("${(book.progress * 100).toStringAsFixed(1)}%"),
              ),
            ),
          );
        },
      ),
    );
  }
}