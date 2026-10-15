import 'package:book_sync/core/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:book_sync/src/data/services/cloud_sync_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainWrapper extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    
    // Configuramos el listener de ciclo de vida aquí mismo
    _lifecycleListener = AppLifecycleListener(
      onPause: () {
        ref.read(autoSyncProvider).triggerSilentSync();
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}