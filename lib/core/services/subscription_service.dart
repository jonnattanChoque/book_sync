// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionService {
  // Clave pública de RevenueCat para iOS (la obtenida en Project Settings -> API Keys)
  static const _apiKeyApple = 'appl_HjFhvsiVlGDTXeLDvYOBczxgsJy';

  static Future<void> initStore() async {
    // 1. Configurar nivel de logs para desarrollo (opcional)
    await Purchases.setLogLevel(LogLevel.debug);

    // 2. Obtener el usuario actual de Supabase
    final supabaseUser = Supabase.instance.client.auth.currentUser;

    late PurchasesConfiguration configuration;

    if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_apiKeyApple);
    } else {
      return; // En caso de que ejecutes en otra plataforma por ahora
    }

    // 3. Vincular con el ID de Supabase si el usuario está autenticado
    if (supabaseUser != null) {
      configuration.appUserID = supabaseUser.id;
    }

    // 4. Configurar el SDK
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
  static Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // 'premium' es el identificador del Entitlement que configuramos en RevenueCat
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logIn(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      print('Error al iniciar sesión en RevenueCat: $e');
    }
  }

  static Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      print('Error al cerrar sesión en RevenueCat: $e');
    }
  }
}