import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibrarySectionsView extends ConsumerWidget {
  const LibrarySectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooksAsync = ref.watch(allBooksProvider);
    final cozy = Theme.of(context).extension<CozyColors>()!;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPaperTexture(),
          _buildLibraryContent(context, cozy, allBooksAsync),
        ]
      )
    );
  }

  DefaultTabController _buildLibraryContent(BuildContext context, CozyColors cozy, AsyncValue<List<Book>> allBooksAsync) {
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          title: Text(AppLocalizations.of(context)!.libraryTitle, style: Theme.of(context).textTheme.titleLarge),
          bottom: TabBar(
            labelColor: cozy.bookmarkColor!,
            unselectedLabelColor: cozy.inkColor!.withValues(alpha: 0.5),
            indicatorColor: cozy.bookmarkColor!.withValues(alpha: 1),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.tabLibraryOne),
              Tab(text: AppLocalizations.of(context)!.tabLibraryTwo), 
              Tab(text: AppLocalizations.of(context)!.tabLibraryThree),
              Tab(text: AppLocalizations.of(context)!.tabLibraryFour),
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
                _BookListSection(books: readingBooks, emptyMessage: AppLocalizations.of(context)!.emptyReading),
                _BookListSection(books: toReadBooks, emptyMessage: AppLocalizations.of(context)!.emptyToRead),
                _BookListSection(books: finishedBooks, emptyMessage: AppLocalizations.of(context)!.emptyFinished),
                _BookListSection(books: forggotenBooks, emptyMessage: AppLocalizations.of(context)!.emptyDropped),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
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
          style: Theme.of(context).textTheme.labelLarge
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
            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(book.author),
              trailing: Text("${(book.progress * 100).toInt()}%"),
            ),
          );
        },
      ),
    );
  }
}