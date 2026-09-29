import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/features/search/data/image_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchImageScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchImageScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchImageScreen> createState() => _SearchImageScreenState();
}

class _SearchImageScreenState extends ConsumerState<SearchImageScreen> {
  late final TextEditingController _searchController = TextEditingController(text: widget.initialQuery);
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showConfirmDialog(String selectedUrl) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.confirmChangeCoverTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.confirmChangeCoverMessage),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(selectedUrl, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.actionCancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el modal de alerta
                context.pop(selectedUrl); // Devuelve la URL a la pantalla de detalle
              },
              child: Text(context.l10n.actionConfirm),
            ),
          ],
        );
      },
    );
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
              ref.read(imageSearchQueryProvider.notifier).clearSearch();
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Text(
              context.l10n.searchImageTitle,
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
                textInputAction: TextInputAction.search,
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.cozy.inkColor!.withValues(alpha: 0.8),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: context.cozy.inkColor!.withValues(alpha: 0.8)),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(imageSearchQueryProvider.notifier).submitQuery('');
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
                    ref.read(imageSearchQueryProvider.notifier).submitQuery('');
                  }
                  setState(() {});
                },
                onSubmitted: (query) {
                  ref.read(imageSearchQueryProvider.notifier).submitQuery(query);
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
              backgroundColor: context.cozy.bookmarkColor!.withValues(alpha: 0.1),
              foregroundColor: context.theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                FocusScope.of(context).unfocus();
                ref.read(imageSearchQueryProvider.notifier).submitQuery(query);
              }
            },
            child: Text(
              context.l10n.searchButton,
              style: context.theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cozy.bookmarkColor!.withValues(alpha: 0.6),
              ),
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
            context.l10n.searchImageHint,
            style: context.theme.textTheme.labelLarge
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList() {
    final searchResultAsync = ref.watch(searchImageCoversProvider);

    return searchResultAsync.when(
      data: (urls) {
        if (urls.isEmpty) {
          return Center(
            child: Text(
              context.l10n.noSearchResults,
              style: context.theme.textTheme.labelLarge,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: urls.length,
          itemBuilder: (context, index) {
            final imageUrl = urls[index];

            return GestureDetector(
              onTap: () => _showConfirmDialog(imageUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderCover(context),
                ),
              ),
            );
          },
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