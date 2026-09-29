import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal transversal para la creación de notas desde cualquier vista.
class AddNoteModal extends ConsumerStatefulWidget {
  final Book book;
  final VoidCallback? onClosePressed;

  const AddNoteModal({
    super.key,
    required this.book, this.onClosePressed,
  });

  static Future<void> show(
    BuildContext context, {
    required Book book,
    VoidCallback? onClosePressed,
  }) async {
    final cozy = Theme.of(context).extension<CozyColors>()!;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      barrierColor: cozy.inkColor!.withValues(alpha: 0.2),
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.bounceOut),
      builder: (context) => AddNoteModal(book: book),
    );

    // Una vez que la modal desaparece de pantalla, ejecutamos el callback
    onClosePressed?.call();
  }

  @override
  ConsumerState<AddNoteModal> createState() => _AddNoteModalState();
}

class _AddNoteModalState extends ConsumerState<AddNoteModal> {
  String _selectedCategory = 'quote';
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  String? _pageErrorText;
  String? _noteErrorText;

  @override
  void initState() {
    super.initState();
    _pageController.text = widget.book.currentPage > 0 
      ? widget.book.currentPage.toString() 
      : '1';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _validateFields(AppLocalizations l10n) {
    setState(() {
      _pageErrorText = null;
      _noteErrorText = null;
    });

    bool isValid = true;

    // 1. Validar Página
    final pageText = _pageController.text.trim();
    final pageNum = int.tryParse(pageText);

    if (pageText.isEmpty || pageNum == null || pageNum <= 0) {
      _pageErrorText = l10n.errorEmptyPage;
      isValid = false;
    } else if (widget.book.totalPages != null && pageNum > widget.book.totalPages!) {
      _pageErrorText = l10n.errorInvalidPageRange(widget.book.totalPages!);
      isValid = false;
    }

    // 2. Validar Nota
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) {
      _noteErrorText = l10n.errorEmptyNote;
      isValid = false;
    }

    setState(() {});
    return isValid;
  }
  
  void _handleSave(AppLocalizations l10n) async {
    if (_validateFields(l10n)) {
      final page = int.parse(_pageController.text.trim());
      final content = _noteController.text.trim();
      final navigator = Navigator.of(context);
      final success = await ref.read(notesNotifierProvider.notifier).createNote(
        bookId: widget.book.id,
        category: _selectedCategory,
        page: page,
        content: content,
      );

      if (!mounted) return;
      if (success) {
        navigator.pop();
        // ignore: use_build_context_synchronously
        CozyToast.showSuccess(context, title: 'Nota agregada');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cozy = theme.extension<CozyColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- CABECERA ---
                _buildTitle(theme, colorScheme, context),
                const SizedBox(height: 16),
      
                // --- 1. CATEGORÍA (CHOICE CHIPS / DROPDOWN) ---
                _buildCategories(l10n, theme, colorScheme, cozy),
                const SizedBox(height: 16),
                // --- 2. FECHA Y 3. PÁGINA (DROPDOWN SCROLL) ---
                _buildTextFieldPage(l10n, theme, colorScheme, cozy),
                const SizedBox(height: 16),
                // --- 4. TEXTFIELD (CONTENIDO DE LA NOTA) ---
                _buildTextFieldNote(l10n, theme, colorScheme, cozy),
                const SizedBox(height: 20),
                // --- BOTÓN DE GUARDAR ---
                _buildButton(l10n, context),
              ],
            ),
          ),
        )
      ),
    );
  }

  Row _buildTitle(ThemeData theme, ColorScheme colorScheme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.book.title,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop()
        ),
      ],
    );
  }

  Row _buildCategories(AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme, CozyColors cozy) {
    final categories = NoteCategoryHelper.getCategories(l10n);
    
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.categoryLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: categories.map((categoryMap) {
                final categoryId = categoryMap['id']!;
                final categoryLabel = categoryMap['label']!;
                final isSelected = _selectedCategory == categoryId;
                    
                  return ChoiceChip(
                    label: Text(categoryLabel),
                    selected: isSelected,
                    selectedColor: cozy.bookmarkColor?.withValues(alpha: 0.2),
                    backgroundColor: theme.cardColor,
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? cozy.bookmarkColor
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                        ? (cozy.bookmarkColor ?? colorScheme.primary)
                        : cozy.inkColor!.withValues(alpha: 0.5),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = categoryId;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildTextFieldPage(AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme, CozyColors cozy) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pageLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  errorText: _pageErrorText,
                  hintText: '1',
                  suffixText: widget.book.totalPages != null 
                      ? '/ ${widget.book.totalPages}' 
                      : null,
                  suffixStyle: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: cozy.inkColor!.withValues(alpha: 0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: cozy.inkColor!.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildTextFieldNote(AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme, CozyColors cozy) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.noteLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  _handleSave(l10n);
                },
                maxLines: 4,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: l10n.noteInputHint,
                  errorText: _noteErrorText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: cozy.inkColor!.withValues(alpha: 0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: cozy.inkColor!.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  PrimaryOutlinedButton _buildButton(AppLocalizations l10n, BuildContext context) {
    return PrimaryOutlinedButton(
      onPressed: () {
        _handleSave(l10n);
      },
      label: l10n.saveNoteButton,
      icon: Icons.check_circle_outline,
    );
  }

}
