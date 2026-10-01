import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/features/search/data/search_repository.dart';
import 'package:book_sync/src/features/search/presentation/widgets/search_book_card_item.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
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
                  _buildTitlte(),

                  // 2. Caja de búsqueda estilizada
                  _buildSearchBox(),

                  // 3. Área de resultados / Estado inicial
                  Expanded(
                    child: _searchController.text.isEmpty
                      ? _buildInitialState()
                      : _buildSearchResultsList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildTitlte() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(AppIcons.back, color: context.theme.colorScheme.onSurface),
            onPressed: () {
              FocusScope.of(context).unfocus();
              ref.read(searchQueryProvider.notifier).clearSearch();
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Text(
              context.l10n.searchTitle,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Row _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: context.cozy.inkColor!.withValues(alpha: 0.5), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                autofocus: true,
                style: TextStyle(
                  color: context.theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.searchPlaceholder,
                  hintStyle: TextStyle(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: context.cozy.inkColor!.withValues(alpha: 0.8)),
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
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PrimaryOutlinedButton(
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  ref.read(searchQueryProvider.notifier).submitQuery(query);
                }
              },
              label: context.l10n.searchButton,
              icon: Icons.search_sharp
            ),
          ),
        )
      ],
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: context.theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.searchInitialHint,
            style: context.theme.textTheme.labelLarge
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList() {
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
                      context.l10n.noSearchResults,
                      style: context.theme.textTheme.labelLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return SearchBookCardItem(
                          book: books[index],
                        );
                    },
                  ),
            ),

            // 2. Botón para agregar manualmente: Solo visible tras buscar
            if (hasSearched) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryOutlinedButton(
                  label: context.l10n.addByManual,
                  icon: AppIcons.addManual,
                  onPressed: () {
                    context.push('/search_detail');
                  },
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: BookLoader(),
      ),
      error: (error, stack) => Center(
        child: Text(
          context.l10n.noSearchResults,
          style: TextStyle(
            color: AppColors.inkCharcoal.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}