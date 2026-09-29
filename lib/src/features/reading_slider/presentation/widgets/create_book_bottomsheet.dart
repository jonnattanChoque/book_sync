import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/handdrawn_button.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBookBottomsheet extends StatelessWidget {
  const CreateBookBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cozy = Theme.of(context).extension<CozyColors>();

    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.addBook,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: cozy!.textColor),
              ),
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/search');
              },
              icon: Icons.search,
              text: AppLocalizations.of(context)!.addBySearch,
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/scanner');
              },
              icon: Icons.document_scanner,
              text: AppLocalizations.of(context)!.addByScan,
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/search_detail');
              },
              icon: Icons.keyboard,
              text: AppLocalizations.of(context)!.addByManual,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}