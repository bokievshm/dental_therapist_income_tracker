import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/notifications_provider.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          // General notifications
          _SettingsSection(
            title: 'General',
            children: [
              _NotificationSwitch(
                title: 'Enable Notifications',
                subtitle: 'Receive notifications from the app',
                value: notificationsState.isEnabled,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).toggleNotifications();
                },
              ),
              if (notificationsState.isEnabled) ...[
                _NotificationSwitch(
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: notificationsState.soundEnabled,
                  onChanged: (value) {
                    ref.read(notificationsProvider.notifier).toggleSound();
                  },
                ),
                _NotificationSwitch(
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: notificationsState.vibrationEnabled,
                  onChanged: (value) {
                    ref.read(notificationsProvider.notifier).toggleVibration();
                  },
                ),
              ],
            ],
          ),
          // Reminders
          _SettingsSection(
            title: 'Reminders',
            children: [
              _NotificationSwitch(
                title: 'Band II Treatment Reminders',
                subtitle: 'Get reminded about Band II treatments',
                value: notificationsState.bandIIRemindersEnabled,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).toggleBandIIReminders();
                },
              ),
              if (notificationsState.bandIIRemindersEnabled)
                _NotificationSwitch(
                  title: 'Daily Reminders',
                  subtitle: 'Receive daily reminders for Band II treatments',
                  value: notificationsState.dailyRemindersEnabled,
                  onChanged: (value) {
                    ref.read(notificationsProvider.notifier).toggleDailyReminders();
                  },
                ),
            ],
          ),
          // Updates
          _SettingsSection(
            title: 'Updates',
            children: [
              _NotificationSwitch(
                title: 'App Updates',
                subtitle: 'Get notified about new app versions',
                value: notificationsState.appUpdatesEnabled,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).toggleAppUpdates();
                },
              ),
              _NotificationSwitch(
                title: 'Feature Announcements',
                subtitle: 'Learn about new features',
                value: notificationsState.featureAnnouncementsEnabled,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).toggleFeatureAnnouncements();
                },
              ),
            ],
          ),
          // Quiet hours
          _SettingsSection(
            title: 'Quiet Hours',
            children: [
              _NotificationSwitch(
                title: 'Enable Quiet Hours',
                subtitle: 'Mute notifications during specific hours',
                value: notificationsState.quietHoursEnabled,
                onChanged: (value) {
                  ref.read(notificationsProvider.notifier).toggleQuietHours();
                },
              ),
              if (notificationsState.quietHoursEnabled)
                ListTile(
                  title: const Text('Quiet Hours'),
                  subtitle: Text(
                    '${notificationsState.quietHoursStart.format(context)} - '
                    '${notificationsState.quietHoursEnd.format(context)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showQuietHoursDialog(context, ref);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showQuietHoursDialog(BuildContext context, WidgetRef ref) async {
    final notificationsState = ref.read(notificationsProvider);
    TimeOfDay? startTime = notificationsState.quietHoursStart;
    TimeOfDay? endTime = notificationsState.quietHoursEnd;

    final result = await showDialog<Map<String, TimeOfDay>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Quiet Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Time'),
              trailing: Text(startTime.format(context)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: startTime,
                );
                if (time != null) {
                  startTime = time;
                }
              },
            ),
            ListTile(
              title: const Text('End Time'),
              trailing: Text(endTime.format(context)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: endTime,
                );
                if (time != null) {
                  endTime = time;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (startTime != null && endTime != null) {
                Navigator.of(context).pop({
                  'start': startTime!,
                  'end': endTime!,
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      ref.read(notificationsProvider.notifier).setQuietHours(
            start: result['start']!,
            end: result['end']!,
          );
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _NotificationSwitch extends ConsumerWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
} 