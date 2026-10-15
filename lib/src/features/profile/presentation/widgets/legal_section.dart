import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  static const String _privacyPolicyUrl = 'https://jonnattanchoque.github.io/book_sync/privacy.html';
  static const String _termsUrl = 'https://jonnattanchoque.github.io/book_sync/terms.html';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.legalSection,
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l10n.privacyPolicyTitle),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () => _launchUrl(_privacyPolicyUrl),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.description_outlined),
          title: Text(l10n.termsOfServiceTitle),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () => _launchUrl(_termsUrl),
        ),
      ],
    );
  }
}