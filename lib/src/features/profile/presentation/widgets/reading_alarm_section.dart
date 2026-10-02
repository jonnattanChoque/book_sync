import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/services/notification_service.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingAlarmSection extends ConsumerStatefulWidget {
  const ReadingAlarmSection({super.key});

  @override
  ConsumerState<ReadingAlarmSection> createState() => _ReadingAlarmSectionState();
}

class _ReadingAlarmSectionState extends ConsumerState<ReadingAlarmSection> {
  late bool _isAlarmEnabled;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // Carga inicial desde el estado global del proveedor
    final settings = ref.read(appSettingsProvider);
    _isAlarmEnabled = settings.isAlarmEnabled;
    _selectedTime = settings.alarmTime;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });

      // Sincronizamos los datos al elegir la nueva hora
      await _syncAlarmSettings(enabled: _isAlarmEnabled, time: picked);
    }
  }

  /// Función auxiliar para sincronizar de forma secuencial la BD y las notificaciones
  Future<void> _syncAlarmSettings({
    required bool enabled,
    required TimeOfDay time,
  }) async {
    try {
      // 1. Guardar en la base de datos/estado persistente
      await ref.read(appSettingsProvider.notifier).updateReadingAlarm(
        isEnabled: enabled,
        alarmTime: time,
      );

      CozyToast.showSuccess(context, title: context.l10n.notificationSaved);

      if (context.mounted) {
        await ref.read(appSettingsProvider.notifier).updateReadingReminder(
          isEnabled: enabled,
          time: time,
          context: context,
        );
      }
    } catch (e) {
      debugPrint('Error sincronizando la alarma: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se escucha el proveedor para reaccionar ante cambios externos
    ref.listen(appSettingsProvider, (previous, next) {
      if (previous?.isAlarmEnabled != next.isAlarmEnabled ||
          previous?.alarmTime != next.alarmTime) {
        setState(() {
          _isAlarmEnabled = next.isAlarmEnabled;
          _selectedTime = next.alarmTime;
        });
      }
    });

    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final cozy = context.cozy;

    return CustomInfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 20,
                color: cozy.bookmarkColor,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.remindersSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Control principal: Switch + Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.readingAlarmTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.readingAlarmSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _isAlarmEnabled,
                activeThumbColor: colorScheme.primary,
                onChanged: (value) async {
                  setState(() {
                    _isAlarmEnabled = value;
                  });

                  if (value) {
                    final hasPermission = await NotificationService.requestPermissions();
                    if (!hasPermission) {
                      if (context.mounted) {
                        CozyToast.showSuccess(
                          context,
                          title: 'Se necesitan permisos de notificación para habilitar la alarma',
                        );
                      }
                      setState(() {
                        _isAlarmEnabled = false;
                      });
                      return;
                    }
                  }

                  // Usamos la misma función centralizada
                  await _syncAlarmSettings(enabled: value, time: _selectedTime);
                },
              ),
            ],
          ),

          // Selector de hora habilitado solo cuando la alarma está activa
          if (_isAlarmEnabled) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            InkWell(
              onTap: () => _selectTime(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cozy.inkColor?.withValues(alpha: 0.05) ??
                      Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: cozy.inkColor?.withValues(alpha: 0.1) ??
                        Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime.format(context),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}