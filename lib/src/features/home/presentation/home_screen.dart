// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/src/features/home/presentation/home_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPaperTexture(),
          
          CustomScrollView(
            slivers: [
              const HomeHeader(),
            ],
          ),
        ],
      ),
    );
  }
}