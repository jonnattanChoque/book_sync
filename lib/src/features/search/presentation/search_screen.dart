import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/features/search/data/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cozy = Theme.of(context).extension<CozyColors>()!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const BackgroundPaperTexture(),
            SafeArea(
              child: Column(
                children: [
                  // 1. Encabezado
                  _buildTitlte(context, l10n),

                  // 2. Caja de búsqueda estilizada
                  _buildSearchBox(l10n, cozy, context),

                  // 3. Área de resultados / Estado inicial
                  Expanded(
                    child: _searchController.text.isEmpty
                      ? _buildInitialState(l10n)
                      : _buildSearchResultsList(l10n, cozy),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildTitlte(BuildContext context, AppLocalizations l10n) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(AppIcons.back, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              FocusScope.of(context).unfocus();
              ref.read(searchQueryProvider.notifier).clearSearch();
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Text(
              l10n.searchTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Row _buildSearchBox(AppLocalizations l10n, CozyColors cozy, BuildContext context) {
    
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: cozy.inkColor!.withValues(alpha: 0.5), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: cozy.inkColor!.withValues(alpha: 0.8),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: cozy.inkColor!.withValues(alpha: 0.8)),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).submitQuery('');
                          setState(() {});
                        },
                      )
                    : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (text) {
                  if (text.trim().isEmpty) {
                    ref.read(searchQueryProvider.notifier).submitQuery('');
                  }
                  setState(() {});
                },
                onSubmitted: (query) {
                  ref.read(searchQueryProvider.notifier).submitQuery(query);
                },
              ),
            ),
          ),
        ),
        
        // Botón de búsqueda fuera del TextField pero alineado en el mismo Row
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: cozy.bookmarkColor!.withValues(alpha: 0.1),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                FocusScope.of(context).unfocus();
                ref.read(searchQueryProvider.notifier).submitQuery(query);
              }
            },
            child: Text(
              l10n.searchButton,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cozy.bookmarkColor!.withValues(alpha: 0.6),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInitialState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.searchInitialHint,
            style: Theme.of(context).textTheme.labelLarge
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList(AppLocalizations l10n, CozyColors cozy) {
    final searchResultAsync = ref.watch(searchBooksProvider);
    final currentQuery = ref.watch(searchQueryProvider);
    
    return searchResultAsync.when(
      data: (books) {
        final hasSearched = currentQuery.trim().isNotEmpty;

        return Column(
          children: [
            // 1. Lista de resultados o mensaje de vacío
            Expanded(
              child: books.isEmpty
                ? Center(
                    child: Text(
                      l10n.noSearchResults,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final theme = Theme.of(context);
                      final colorScheme = theme.colorScheme;
                      
                      return Card(
                        color: theme.cardColor.withValues(alpha: 0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                              ? Image.network(
                                  book.coverUrl!,
                                  width: 48,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPlaceholderCover(context),
                                )
                              : _buildPlaceholderCover(context),
                          ),
                          title: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              book.authors.isNotEmpty ? book.authors.join(', ') : '---',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                          onTap: () {
                            context.push('/search_detail', extra: book);
                          },
                        ),
                      );
                    },
                  ),
            ),

            // 2. Botón para agregar manualmente: Solo visible tras buscar
            if (hasSearched) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryOutlinedButton(
                  label: l10n.addByManual,
                  icon: AppIcons.addManual,
                  onPressed: () {
                    // Navega a la pantalla de detalle editable en modo manual (sin DTO)
                    context.push('/search_detail');
                  },
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.inkCharcoal,
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          l10n.noSearchResults,
          style: TextStyle(
            color: AppColors.inkCharcoal.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover(BuildContext context) {
    return Container(
      width: 48,
      height: 70,
      color: AppColors.inkCharcoal.withValues(alpha: 0.1),
      child: Icon(
        Icons.book,
        color: AppColors.inkCharcoal.withValues(alpha: 0.4),
      ),
    );
  }
}