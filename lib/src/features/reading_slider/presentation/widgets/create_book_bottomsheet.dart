import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/handdrawn_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBookBottomsheet extends StatelessWidget {
  const CreateBookBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(
                context.l10n.addBook,
                style: context.theme.textTheme.titleLarge?.copyWith(color: context.cozy.textColor),
              ),
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/search');
              },
              icon: Icons.search,
              text: context.l10n.addBySearch,
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/scanner');
              },
              icon: Icons.document_scanner,
              text: context.l10n.addByScan,
            ),
            HandDrawnButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/search_detail');
              },
              icon: Icons.keyboard,
              text: context.l10n.addByManual,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}