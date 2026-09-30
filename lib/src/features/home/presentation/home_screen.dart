// ignore: depend_on_referenced_packages
import 'package:book_sync/src/features/home/presentation/widgets/home_library_card.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_profile_card.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_stats_card.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_streak_card.dart';
import 'package:book_sync/src/features/reading_slider/presentation/widgets/reading_slider.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_header.dart';
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
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),
              const SliverToBoxAdapter(
                child: ReadingSlider(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              const SliverToBoxAdapter(
                child: HomeLibraryCard(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              const SliverToBoxAdapter(
                child: HomeStreakCard(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              const SliverToBoxAdapter(
                child: StatsCard(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              const SliverToBoxAdapter(
                child: HomeProfileCard(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}