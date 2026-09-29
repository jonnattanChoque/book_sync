import 'package:book_sync/l10n/app_localizations.dart';

class NoteCategoryHelper {
  /// Devuelve la lista completa de categorías con su 'id' fijo y su 'label' traducido
  static List<Map<String, String>> getCategories(AppLocalizations l10n) {
    return [
      {'id': 'quote', 'label': l10n.categoryQuote},
      {'id': 'summary', 'label': l10n.categorySummary},
      {'id': 'question', 'label': l10n.categoryQuestion},
      {'id': 'reflection', 'label': l10n.categoryReflection},
      {'id': 'idea', 'label': l10n.categoryIdea},
      {'id': 'other', 'label': l10n.categoryOther},
    ];
  }

  /// Dado un 'id' guardado en Isar (ej: 'quote'), busca y devuelve su 'label' localizado.
  /// Si no lo encuentra, devuelve el mismo 'id' como respaldo.
  static String getLabelById(String categoryId, AppLocalizations l10n) {
    final categories = getCategories(l10n);
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'id': categoryId, 'label': categoryId},
    );
    return category['label']!;
  }
}