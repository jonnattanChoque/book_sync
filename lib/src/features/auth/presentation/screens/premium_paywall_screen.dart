// ignore_for_file: deprecated_member_use

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/services/subscription_service.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumPaywallScreen extends ConsumerStatefulWidget {
  final String contentText;
  
  const PremiumPaywallScreen({super.key, required this.contentText});

  @override
  ConsumerState<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends ConsumerState<PremiumPaywallScreen> {
  bool isPurchasing = false;
  PackageType selectedPackageType = PackageType.annual;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundPaperTexture(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buiildNav(context),
          body: _buildContent(),
        ),
      ],
    );
  }

  AppBar _buiildNav(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(context.l10n.exportPremiumTitle, style: context.theme.textTheme.titleLarge),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  FutureBuilder<List<Package>> _buildContent() {
    return FutureBuilder<List<Package>>(
      future: SubscriptionService.getAvailablePackages(),
      builder: (context, snapshot) {
        final packages = snapshot.data ?? [];

        final Package? annualPackage = packages.cast<Package?>().firstWhere(
          (p) => p?.packageType == PackageType.annual,
          orElse: () => null,
        );

        final Package? monthlyPackage = packages.cast<Package?>().firstWhere(
          (p) => p?.packageType == PackageType.monthly,
          orElse: () => null,
        );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabecera
                const Icon(Icons.workspace_premium, size: 56, color: Colors.amber),
                const SizedBox(height: 12),
                Text(
                  widget.contentText,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Tabla Comparativa de Características
                _buildComparisonTable(context),
                const SizedBox(height: 24),

                // Selección de Planes (Tus RadioListTile originales)
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else ...[
                  if (annualPackage != null)
                    RadioListTile<PackageType>(
                      value: PackageType.annual,
                      groupValue: selectedPackageType,
                      title: Text(context.l10n.annualPlanTitle),
                      subtitle: Text(
                        context.l10n.annualPlanSubtitle(
                          annualPackage.storeProduct.priceString,
                        ),
                      ),
                      onChanged: isPurchasing
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() => selectedPackageType = value);
                              }
                            },
                    ),
                  if (monthlyPackage != null)
                    RadioListTile<PackageType>(
                      value: PackageType.monthly,
                      groupValue: selectedPackageType,
                      title: Text(context.l10n.monthlyPlanTitle),
                      subtitle: Text(
                        context.l10n.monthlyPlanSubtitle(
                          monthlyPackage.storeProduct.priceString,
                        ),
                      ),
                      onChanged: isPurchasing
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => selectedPackageType = value);
                          }
                        },
                    ),
                ],

                const SizedBox(height: 32),

                // Botón de Compra
                ElevatedButton(
                  onPressed: (isPurchasing || packages.isEmpty)
                  ? null
                  : () async {
                      setState(() {
                        isPurchasing = true;
                      });

                      try {
                        final packageToPurchase = packages.firstWhere(
                          (p) => p.packageType == selectedPackageType,
                          orElse: () => packages.first,
                        );

                        final result = await Purchases.purchasePackage(packageToPurchase);
                        final isPremium = result.customerInfo.entitlements.all['premium']?.isActive ?? false;
                        ref.read(appSettingsProvider.notifier).updatePremium(isPremium);
                        
                        if (isPremium && mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        // Manejo de cancelación o error
                      } finally {
                        if (mounted) {
                          setState(() {
                            isPurchasing = false;
                          });
                        }
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isPurchasing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      context.l10n.exportUpgradeButton,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget auxiliar para construir la tabla comparativa de manera limpia
  Widget _buildComparisonTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Característica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                Expanded(flex: 2, child: Text('Gratis', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                Expanded(flex: 2, child: Text('PRO', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber))),
              ],
            ),
          ),
          _buildRow('Exportar estadísticas', false, true),
          const Divider(height: 1),
          _buildRow('Gráficos avanzados', false, true),
          const Divider(height: 1),
          _buildRow('Sincronización en la nube', true, true),
        ],
      ),
    );
  }

  Widget _buildRow(String feature, bool free, bool pro) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(feature, style: const TextStyle(fontSize: 12))),
          Expanded(flex: 2, child: Center(child: free ? const Icon(Icons.check, color: Colors.green, size: 18) : const Icon(Icons.close, color: Colors.red, size: 18))),
          Expanded(flex: 2, child: Center(child: pro ? const Icon(Icons.check, color: Colors.amber, size: 18) : const Icon(Icons.close, color: Colors.grey, size: 18))),
        ],
      ),
    );
  }
}