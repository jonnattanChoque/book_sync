import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookSearchDetailScreen extends ConsumerStatefulWidget {
  final BookSearchDto? book;

  const BookSearchDetailScreen({
    super.key,
    this.book,
  });

  @override
  ConsumerState<BookSearchDetailScreen> createState() => _BookSearchDetailScreenState();
}

class _BookSearchDetailScreenState extends ConsumerState<BookSearchDetailScreen> {
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

    _checkDuplicateIsbn();
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

  Future<void> _saveBook() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _checkDuplicateIsbn();

    final repository = ref.read(bookRepositoryProvider);

    final newBookId = await repository.saveBookFromForm(
      title: _titleController.text.trim(),
      author: _authorsController.text.trim(),
      status: _selectedStatus,
      coverPath: _coverUrl,
      startedAt: _selectedStatus == BookStatus.reading ? DateTime.now() : null,
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

    ref.read(selectedBookIdProvider.notifier).state = newBookId;

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _checkDuplicateIsbn() async {
    final isbn = _isbnController.text.trim();

    final checkDuplicateIsbn = ref.read(checkDuplicateIsbnProvider);
    final existingBook = await checkDuplicateIsbn(isbn);

    if (!mounted) return;
    if (existingBook != null) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.duplicateBookTitle),
            content: Text(context.l10n.duplicateBookMessage),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  context.pushReplacement('/')
                },
                child: Text(context.l10n.accept),
              ),
            ],
          );
        },
      );
          return;
    }
  }

  @override
  Widget build(BuildContext context) {

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildTitle(),
            body: Form(
              key: _formKey,
              child: _buildScrollContent(),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildTitle() {
    final isManual = widget.book == null;
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          AppIcons.back,
          color: context.colorScheme.onSurface,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        isManual ? context.l10n.addManualBook : context.l10n.addBookTitle,
        style: context.theme.textTheme.titleLarge,
      ),
    );
  }

  SingleChildScrollView _buildScrollContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Portada del libro centrada
          _buildCover(_titleController.text),
          const SizedBox(height: 24),

          // 2. Sección Información Principal
          _buildSectionHeader(context.l10n.sectionInfo),
          _buildDetailCard(
             true,
            children: [
              _buildEditableRow(
                label: context.l10n.fieldTitle,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.validationTitleRequired;
                  }
                  return null;
                },
              ),
              _buildDivider(),
              _buildEditableRow(
                label: context.l10n.fieldAuthors,
                controller: _authorsController,
              ),
              _buildDivider(),
              _buildEditableRow(
                label: context.l10n.fieldIsbn,
                controller: _isbnController,
              ),
              _buildDivider(),
              _buildEditableRow(
                label: context.l10n.fieldLanguage,
                controller: _languageController,
              ),
              _buildDivider(),
              _buildEditableRow(
                label: context.l10n.fieldPages,
                controller: _pagesController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.validationTotalPagesRequired;
                  }
                  final pages = int.tryParse(value.trim());
                  if (pages == null || pages <= 0) {
                    return context.l10n.validationTotalPagesInvalid;
                  }
                  return null; // Válido
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildSectionHeader(context.l10n.sectionSelected),
          _buildDetailCard(false, children: [_buildStatusSelector()]),
          const SizedBox(height: 20),

          // 3. Sección Descripción
          _buildSectionHeader(context.l10n.sectionDescription),
          _buildDetailCard(
             true,
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                minLines: 2,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Añade una descripción...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Sección Editorial
          _buildSectionHeader(context.l10n.sectionPublisher),
          _buildDetailCard(
             true,
            children: [
              _buildEditableRow(
                label: context.l10n.fieldPublisher,
                controller: _publisherController,
              ),
              _buildDivider(),
              _buildEditableRow(
                label: context.l10n.fieldPublishedDate,
                controller: _publishedDateController,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 5. Sección Otros
          _buildSectionHeader(context.l10n.sectionOther),
          _buildDetailCard(
             true,
            children: [
              _buildEditableRow(
                label: context.l10n.fieldCategories,
                controller: _categoriesController,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 6. Botón de Acción Principal
          PrimaryOutlinedButton(
            label: context.l10n.btnSaveToLibrary,
            icon: AppIcons.save,
            onPressed: _saveBook
            ,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: context.theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Center _buildCover(String title) {
    return Center(
      child: Stack(
        children: [
          Container(
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
                        _buildPlaceholderCover(),
                  )
                : _buildPlaceholderCover(),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Material(
              color: context.theme.primaryColor,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final String? newCoverUrl = await context.push<String>(
                    '/search_image',
                    extra: title,
                  );

                  if (newCoverUrl != null && newCoverUrl.isNotEmpty) {
                    setState(() {
                      _coverUrl = newCoverUrl;
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    return SegmentedButton<BookStatus>(
      segments: [
        ButtonSegment(
          value: BookStatus.toRead,
          label: Text(context.l10n.tabLibraryToRead),
          icon: Icon(Icons.bookmark_border),
        ),
        ButtonSegment(
          value: BookStatus.reading,
          label: Text(context.l10n.tabLibraryReading),
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

  Widget _buildDetailCard(bool isBorderless, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBorderless ? context.theme.cardColor.withValues(alpha: 0.8) : null,
        borderRadius: isBorderless ? BorderRadius.circular(14) : BorderRadius.circular(0),
        border: isBorderless ? Border.all(
          color: context.theme.colorScheme.outline.withValues(alpha: 0.15),
        ) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                errorMaxLines: 2,
                helperMaxLines: 2,
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                hintText: '---',
                hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 12,
      thickness: 1,
      color: context.theme.colorScheme.outline.withValues(alpha: 0.1),
    );
  }

  Widget _buildPlaceholderCover() {
    final colorScheme = context.theme.colorScheme;
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