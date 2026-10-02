import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeAndLanguageSection extends ConsumerStatefulWidget {
  const ThemeAndLanguageSection({super.key});

  @override
  ConsumerState<ThemeAndLanguageSection> createState() =>
      _ThemeAndLanguageSectionState();
}

class _ThemeAndLanguageSectionState extends ConsumerState<ThemeAndLanguageSection> {

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final cozy = context.cozy;
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return CustomInfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la sección
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20,
                color: cozy.bookmarkColor,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.settingsSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // 3.4.2 TEMAS: Switch/Toggle para Modo Oscuro
          // -------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    settings.themeMode == ThemeMode.dark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    size: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.themeTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Switch(
                value: settings.themeMode == ThemeMode.dark,
                activeThumbColor: colorScheme.primary,
                onChanged: (value) {
                  notifier.updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1),
          ),

          // -------------------------------------------------------------------
          // 3.4.3 IDIOMA: Toggle con botones (Español / Inglés)
          // -------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language_outlined,
                    size: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.languageTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              // Selector estilo Toggle / SegmentedButton para Español e Inglés
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: cozy.inkColor?.withValues(alpha: 0.08) ??
                      Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LanguageOptionButton(
                      label: '🇪🇸 ES',
                      isSelected: settings.locale == Locale('es'),
                      onTap: () {
                        notifier.updateLocale(Locale('es'));
                      },
                    ),
                    const SizedBox(width: 2),
                    _LanguageOptionButton(
                      label: '🇺🇸 EN',
                      isSelected: settings.locale == Locale('en'),
                      onTap: () {
                        notifier.updateLocale(Locale('en'));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Botón selector individual para el idioma
class _LanguageOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}