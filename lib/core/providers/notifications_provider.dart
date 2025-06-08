import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notifications_service.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService();
});

final notificationSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(notificationsServiceProvider);
  return service.getNotificationSettings();
});

final notificationSettingProvider = StateNotifierProvider.family<NotificationSettingNotifier, bool, String>((ref, setting) {
  return NotificationSettingNotifier(ref.watch(notificationsServiceProvider), setting);
});

final band2ReminderSettingsProvider = StateNotifierProvider<Band2ReminderSettingsNotifier, Band2ReminderSettings>((ref) {
  return Band2ReminderSettingsNotifier(ref.watch(notificationsServiceProvider));
});

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});

class NotificationsState {
  final bool enabled;
  final bool sound;
  final bool vibration;
  final bool bandIIReminders;
  final bool dailyReminders;
  final bool appUpdates;
  final bool featureAnnouncements;
  final bool quietHours;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  NotificationsState({
    this.enabled = true,
    this.sound = true,
    this.vibration = true,
    this.bandIIReminders = true,
    this.dailyReminders = true,
    this.appUpdates = true,
    this.featureAnnouncements = true,
    this.quietHours = false,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  NotificationsState copyWith({
    bool? enabled,
    bool? sound,
    bool? vibration,
    bool? bandIIReminders,
    bool? dailyReminders,
    bool? appUpdates,
    bool? featureAnnouncements,
    bool? quietHours,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationsState(
      enabled: enabled ?? this.enabled,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      bandIIReminders: bandIIReminders ?? this.bandIIReminders,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      appUpdates: appUpdates ?? this.appUpdates,
      featureAnnouncements: featureAnnouncements ?? this.featureAnnouncements,
      quietHours: quietHours ?? this.quietHours,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(NotificationsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationsState(
      enabled: prefs.getBool('notifications_enabled') ?? true,
      sound: prefs.getBool('notifications_sound') ?? true,
      vibration: prefs.getBool('notifications_vibration') ?? true,
      bandIIReminders: prefs.getBool('notifications_band_ii') ?? true,
      dailyReminders: prefs.getBool('notifications_daily') ?? true,
      appUpdates: prefs.getBool('notifications_app_updates') ?? true,
      featureAnnouncements: prefs.getBool('notifications_features') ?? true,
      quietHours: prefs.getBool('notifications_quiet_hours') ?? false,
      quietHoursStart: _loadTimeOfDay(prefs, 'notifications_quiet_hours_start'),
      quietHoursEnd: _loadTimeOfDay(prefs, 'notifications_quiet_hours_end'),
    );
  }

  TimeOfDay? _loadTimeOfDay(SharedPreferences prefs, String key) {
    final hour = prefs.getInt('${key}_hour');
    final minute = prefs.getInt('${key}_minute');
    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  Future<void> _saveTimeOfDay(SharedPreferences prefs, String key, TimeOfDay time) async {
    await prefs.setInt('${key}_hour', time.hour);
    await prefs.setInt('${key}_minute', time.minute);
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    state = state.copyWith(enabled: value);
  }

  Future<void> toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_sound', value);
    state = state.copyWith(sound: value);
  }

  Future<void> toggleVibration(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_vibration', value);
    state = state.copyWith(vibration: value);
  }

  Future<void> toggleBandIIReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_band_ii', value);
    state = state.copyWith(bandIIReminders: value);
  }

  Future<void> toggleDailyReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_daily', value);
    state = state.copyWith(dailyReminders: value);
  }

  Future<void> toggleAppUpdates(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_app_updates', value);
    state = state.copyWith(appUpdates: value);
  }

  Future<void> toggleFeatureAnnouncements(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_features', value);
    state = state.copyWith(featureAnnouncements: value);
  }

  Future<void> toggleQuietHours(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_quiet_hours', value);
    state = state.copyWith(quietHours: value);
  }

  Future<void> setQuietHours(TimeOfDay start, TimeOfDay end) async {
    final prefs = await SharedPreferences.getInstance();
    await _saveTimeOfDay(prefs, 'notifications_quiet_hours_start', start);
    await _saveTimeOfDay(prefs, 'notifications_quiet_hours_end', end);
    state = state.copyWith(
      quietHoursStart: start,
      quietHoursEnd: end,
    );
  }
}

class NotificationSettingNotifier extends StateNotifier<bool> {
  final NotificationsService _service;
  final String _setting;

  NotificationSettingNotifier(this._service, this._setting) : super(false) {
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final settings = await _service.getNotificationSettings();
    state = settings[_setting] as bool? ?? false;
  }

  Future<void> toggle() async {
    final newValue = !state;
    await _service.toggleNotificationSetting(_setting, newValue);
    state = newValue;
  }
}

class Band2ReminderSettings {
  final bool enabled;
  final int time;
  final String unit;

  Band2ReminderSettings({
    required this.enabled,
    required this.time,
    required this.unit,
  });

  factory Band2ReminderSettings.fromMap(Map<String, dynamic> map) {
    return Band2ReminderSettings(
      enabled: map['band2Reminders'] as bool? ?? true,
      time: map['band2ReminderTime'] as int? ?? 2,
      unit: map['band2ReminderUnit'] as String? ?? 'months',
    );
  }
}

class Band2ReminderSettingsNotifier extends StateNotifier<Band2ReminderSettings> {
  final NotificationsService _service;

  Band2ReminderSettingsNotifier(this._service)
      : super(Band2ReminderSettings(enabled: true, time: 2, unit: 'months')) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _service.getNotificationSettings();
    state = Band2ReminderSettings.fromMap(settings);
  }

  Future<void> updateSettings({
    required bool enabled,
    required int time,
    required String unit,
  }) async {
    await _service.updateBand2ReminderSettings(
      enabled: enabled,
      time: time,
      unit: unit,
    );
    state = Band2ReminderSettings(
      enabled: enabled,
      time: time,
      unit: unit,
    );
  }
} 