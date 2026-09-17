import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:flutter/material.dart';

class HandDrawnButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const HandDrawnButton({
    super.key,
    required this.onPressed,
    required this.icon, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final cozy = Theme.of(context).extension<CozyColors>()!;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: cozy.inkColor!.withValues(alpha: 0.5), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: cozy.inkColor!.withValues(alpha: 0.8)),
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}