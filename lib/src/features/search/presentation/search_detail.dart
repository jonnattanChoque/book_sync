import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  /// Si es `null`, se asume flujo de creación manual desde cero.
  final BookSearchDto? book;

  const BookDetailScreen({
    super.key,
    this.book,
  });

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos editables
  late final TextEditingController _titleController;
  late final TextEditingController _authorsController;
  late final TextEditingController _isbnController;
  late final TextEditingController _languageController;
  late final TextEditingController _pagesController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _publisherController;
  late final TextEditingController _publishedDateController;
  late final TextEditingController _categoriesController;

  String? _coverUrl;
  BookStatus _selectedStatus = BookStatus.toRead;

  @override
  void initState() {
    super.initState();
    final book = widget.book;

    // Prellenado de datos si provienen de la búsqueda
    _coverUrl = book?.coverUrl;
    _titleController = TextEditingController(text: book?.title ?? '');
    _authorsController = TextEditingController(
      text: book?.authors.isNotEmpty == true ? book!.authors.join(', ') : '',
    );
    _isbnController = TextEditingController(text: book?.isbn ?? '');
    _languageController = TextEditingController(text: book?.language ?? '');
    _pagesController = TextEditingController(
      text: (book?.pageCount != null && book!.pageCount! > 0)
          ? '${book.pageCount}'
          : '',
    );
    _descriptionController = TextEditingController(text: book?.description ?? '');
    _publisherController = TextEditingController(text: book?.publisher ?? '');
    _publishedDateController = TextEditingController(text: book?.publishedDate ?? '');
    _categoriesController = TextEditingController(
      text: book?.categories.isNotEmpty == true ? book!.categories.join(', ') : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _isbnController.dispose();
    _languageController.dispose();
    _pagesController.dispose();
    _descriptionController.dispose();
    _publisherController.dispose();
    _publishedDateController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  // En _BookDetailScreenState

  Future<void> _saveBook() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final repository = ref.read(bookRepositoryProvider);

    final newBookId = await repository.saveBookFromForm(
      title: _titleController.text.trim(),
      author: _authorsController.text.trim(),
      status: _selectedStatus,
      coverPath: _coverUrl,
      totalPages: int.tryParse(_pagesController.text.trim()),
      isbn: _isbnController.text.trim().isEmpty ? null : _isbnController.text.trim(),
      language: _languageController.text.trim().isEmpty ? null : _languageController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      publisher: _publisherController.text.trim().isEmpty ? null : _publisherController.text.trim(),
      publishedDate: _publishedDateController.text.trim().isEmpty ? null : _publishedDateController.text.trim(),
      categories: _categoriesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    // Notificamos el libro seleccionado para mover el carrusel en el Home
    ref.read(selectedBookIdProvider.notifier).state = newBookId;

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildTitle(colorScheme, context, l10n, theme),
            body: Form(
              key: _formKey,
              child: _buildScrollContent(context, l10n, theme, colorScheme),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildTitle(
    ColorScheme colorScheme,
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isManual = widget.book == null;
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          AppIcons.back,
          color: colorScheme.onSurface,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        isManual ? l10n.addManualBook : l10n.addBookTitle,
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SingleChildScrollView _buildScrollContent(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Portada del libro centrada
          Center(
            child: Container(
              width: 140,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _coverUrl != null && _coverUrl!.isNotEmpty
                    ? Image.network(
                        _coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderCover(context),
                      )
                    : _buildPlaceholderCover(context),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Sección Información Principal
          _buildSectionHeader(context, l10n.sectionInfo),
          _buildDetailCard(
            context,
             true,
            children: [
              _buildEditableRow(
                context,
                label: l10n.fieldTitle,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              _buildDivider(context),
              _buildEditableRow(
                context,
                label: l10n.fieldAuthors,
                controller: _authorsController,
              ),
              _buildDivider(context),
              _buildEditableRow(
                context,
                label: l10n.fieldIsbn,
                controller: _isbnController,
              ),
              _buildDivider(context),
              _buildEditableRow(
                context,
                label: l10n.fieldLanguage,
                controller: _languageController,
              ),
              _buildDivider(context),
              _buildEditableRow(
                context,
                label: l10n.fieldPages,
                controller: _pagesController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildSectionHeader(context, l10n.sectionSelected),
          _buildDetailCard(context, false, children: [_buildStatusSelector(l10n)]),
          const SizedBox(height: 20),

          // 3. Sección Descripción
          _buildSectionHeader(context, l10n.sectionDescription),
          _buildDetailCard(
            context,
             true,
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                minLines: 2,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Añade una descripción...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Sección Editorial
          _buildSectionHeader(context, l10n.sectionPublisher),
          _buildDetailCard(
            context,
             true,
            children: [
              _buildEditableRow(
                context,
                label: l10n.fieldPublisher,
                controller: _publisherController,
              ),
              _buildDivider(context),
              _buildEditableRow(
                context,
                label: l10n.fieldPublishedDate,
                controller: _publishedDateController,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 5. Sección Otros
          _buildSectionHeader(context, l10n.sectionOther),
          _buildDetailCard(
            context,
             true,
            children: [
              _buildEditableRow(
                context,
                label: l10n.fieldCategories,
                controller: _categoriesController,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 6. Botón de Acción Principal
          PrimaryOutlinedButton(
            label: l10n.btnSaveToLibrary,
            icon: AppIcons.save,
            onPressed: _saveBook
            ,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusSelector(AppLocalizations l10n) {
    return SegmentedButton<BookStatus>(
      segments: [
        ButtonSegment(
          value: BookStatus.toRead,
          label: Text(l10n.tabLibraryTwo),
          icon: Icon(Icons.bookmark_border),
        ),
        ButtonSegment(
          value: BookStatus.reading,
          label: Text(l10n.tabLibraryOne),
          icon: Icon(Icons.book),
        ),
      ],
      selected: {_selectedStatus},
      onSelectionChanged: (newSelection) {
        setState(() {
          _selectedStatus = newSelection.first;
        });
      },
    );
  }

  Widget _buildDetailCard(BuildContext context, bool isBorderless, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBorderless ? theme.cardColor.withValues(alpha: 0.8) : null,
        borderRadius: isBorderless ? BorderRadius.circular(14) : BorderRadius.circular(0),
        border: isBorderless ? Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Fila editable con campo de texto integrado en el estilo visual
  Widget _buildEditableRow(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                hintText: '---',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 12,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
    );
  }

  Widget _buildPlaceholderCover(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        AppIcons.bookPlaceholder,
        size: 48,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}