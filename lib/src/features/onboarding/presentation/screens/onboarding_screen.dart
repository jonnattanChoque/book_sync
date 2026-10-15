// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/data/services/cloud_sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:go_router/go_router.dart';
// TODO: Asegúrate de importar tu servicio/proveedor de preferencias para guardar que ya se vio el onboarding

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(appSettingsProvider.notifier).updateOnboarding(true);
      await ref.read(autoSyncProvider).triggerSilentSync();
      
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(appSettingsProvider);
    final language = settings.locale.languageCode;

    final List<OnboardingStepData> _steps = [
      OnboardingStepData(
        title: context.l10n.onboardingStep1Title ,
        subtitle: context.l10n.onboardingStep1Subtitle,
        imagePath: "assets/onboarding/step_1_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep2Title ,
        subtitle: context.l10n.onboardingStep2Subtitle,
        imagePath: "assets/onboarding/step_2_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep3Title ,
        subtitle: context.l10n.onboardingStep3Subtitle,
        imagePath: "assets/onboarding/step_3_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep4Title ,
        subtitle: context.l10n.onboardingStep4Subtitle,
        imagePath: "assets/onboarding/step_4_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep5Title ,
        subtitle: context.l10n.onboardingStep5Subtitle,
        imagePath: "assets/onboarding/step_5_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep6Title ,
        subtitle: context.l10n.onboardingStep6Subtitle,
        imagePath: "assets/onboarding/step_6_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep7Title ,
        subtitle: context.l10n.onboardingStep7Subtitle,
        imagePath: "assets/onboarding/step_7_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep8Title ,
        subtitle: context.l10n.onboardingStep8Subtitle,
        imagePath: "assets/onboarding/step_8_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep9Title ,
        subtitle: context.l10n.onboardingStep9Subtitle,
        imagePath: "assets/onboarding/step_9_slider_$language.jpg",
      ),
      OnboardingStepData(
        title: context.l10n.onboardingStep10Title ,
        subtitle: context.l10n.onboardingStep10Subtitle,
        imagePath: "assets/onboarding/step_10_slider_$language.jpg",
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundPaperTexture()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_currentPage < _steps.length - 1)
                        TextButton(
                          onPressed: () {
                            context.go('/');
                          },
                          child: Text(
                            context.l10n.onboardingSkip,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Carrusel de pantallas (PageView)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _steps.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            // Títulos explicativos
                            Text(
                              step.title,
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              step.subtitle,
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8,),
                            // Contenedor del Screenshot con tarjeta estilizada
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: 350,
                                decoration: BoxDecoration(
                                  color: context.theme.cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  child: Image.asset(
                                    step.imagePath,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) => Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 48,
                                            color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Screenshot no encontrado",
                                            style: context.theme.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Controles inferiores (Indicadores y Botones)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicadores de puntos (Dots)
                      Row(
                        children: List.generate(
                          _steps.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? context.colorScheme.primary
                                  : context.colorScheme.onSurface.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Botón Siguiente / Comenzar
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_currentPage < _steps.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finishOnboarding();
                          }
                        },
                        child: Text(
                          _currentPage == _steps.length - 1 ? context.l10n.onboardingStart : context.l10n.onboardingNext,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
          if (_isLoading) BookLoader()
        ],
      ),
    );
  }
}

class OnboardingStepData {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardingStepData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}