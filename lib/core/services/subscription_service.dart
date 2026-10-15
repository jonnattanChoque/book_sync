// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SubscriptionResult {
  final bool isPremium;
  final bool showExpirationBanner;
  final bool isExpired;

  SubscriptionResult({
    required this.isPremium,
    required this.showExpirationBanner,
    required this.isExpired,
  });
}

class SubscriptionService {
  // Clave pública de RevenueCat para iOS (la obtenida en Project Settings -> API Keys)
  static const _apiKeyApple = 'appl_HjFhvsiVlGDTXeLDvYOBczxgsJy';
  static const _apiKeyGoogle = 'goog_YTbSSzPEEevNznWZqPAmNEKZkDO';

  static Future<void> initStore() async {
    await Purchases.setLogLevel(LogLevel.debug);

    final supabaseUser = Supabase.instance.client.auth.currentUser;

    late PurchasesConfiguration configuration;

    if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_apiKeyApple);
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKeyGoogle);
    } else {
      return; // Otras plataformas no soportadas
    }

    if (supabaseUser != null) {
      configuration.appUserID = supabaseUser.id;
    }

    await Purchases.configure(configuration);
  }

  static Future<List<Package>> getAvailablePackages() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> purchaseSubscription() async {
    try {
      // 1. Obtener los planes configurados en RevenueCat ('default')
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        // Seleccionamos el plan mensual ($rc_monthly) o puedes usar .annual!
        Package package = offerings.current!.monthly!;

        // 2. Ejecutar la compra (despliega la hoja de pago nativa de Apple)
        PurchaseResult purchaseResult = await Purchases.purchasePackage(package);
        CustomerInfo customerInfo = purchaseResult.customerInfo;

        // 3. Verificar si se activó el permiso 'premium'
        return customerInfo.entitlements.all['premium']?.isActive ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Método para verificar si el usuario tiene la suscripción activa
  static Future<SubscriptionResult> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.all['premium'];
      
      final isActive = entitlement?.isActive ?? false;
      final expirationDate = entitlement?.expirationDate;
      final showBanner = isActive && isExpiringSoon(expirationDate);

      // Determinamos si expiró: 
      // El entitlement existe pero ya no está activo (es decir, tuvo una suscripción previa que venció)
      final hasExpired = entitlement != null && !isActive;

      return SubscriptionResult(
        isPremium: isActive,
        showExpirationBanner: showBanner,
        isExpired: hasExpired,
      );
    } catch (e) {
      return SubscriptionResult(
        isPremium: false, 
        showExpirationBanner: false,
        isExpired: false,
      );
    }
  }

  static Future<void> logIn(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      debugPrint('Error al iniciar sesión en RevenueCat: $e');
    }
  }

  static Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint('Error al cerrar sesión en RevenueCat: $e');
    }
  }

  static  bool isExpiringSoon(String? expirationDateStr) {
    if (expirationDateStr == null) return false;
    
    final expirationDate = DateTime.parse(expirationDateStr);
    final now = DateTime.now();
    final difference = expirationDate.difference(now);
    return difference.inHours <= 3 && !difference.isNegative;
  }
}