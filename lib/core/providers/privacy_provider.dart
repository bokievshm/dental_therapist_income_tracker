import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/privacy_service.dart';

final privacyServiceProvider = Provider<PrivacyService>((ref) {
  return PrivacyService();
});

final privacySettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(privacyServiceProvider);
  return service.getPrivacySettings();
});

final privacySettingProvider = StateNotifierProvider.family<PrivacySettingNotifier, bool, String>((ref, setting) {
  return PrivacySettingNotifier(ref.watch(privacyServiceProvider), setting);
});

class PrivacySettingNotifier extends StateNotifier<bool> {
  final PrivacyService _service;
  final String _setting;

  PrivacySettingNotifier(this._service, this._setting) : super(false) {
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final settings = await _service.getPrivacySettings();
    state = settings[_setting] as bool? ?? false;
  }

  Future<void> toggle() async {
    final newValue = !state;
    await _service.togglePrivacySetting(_setting, newValue);
    state = newValue;
  }
}

final passwordChangeProvider = StateNotifierProvider<PasswordChangeNotifier, AsyncValue<void>>((ref) {
  return PasswordChangeNotifier(ref.watch(privacyServiceProvider));
});

class PasswordChangeNotifier extends StateNotifier<AsyncValue<void>> {
  final PrivacyService _service;

  PasswordChangeNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _service.updatePassword(currentPassword, newPassword);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final twoFactorAuthProvider = StateNotifierProvider<TwoFactorAuthNotifier, AsyncValue<void>>((ref) {
  return TwoFactorAuthNotifier(ref.watch(privacyServiceProvider));
});

class TwoFactorAuthNotifier extends StateNotifier<AsyncValue<void>> {
  final PrivacyService _service;

  TwoFactorAuthNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> enable() async {
    state = const AsyncValue.loading();
    try {
      await _service.enableTwoFactorAuth();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> disable() async {
    state = const AsyncValue.loading();
    try {
      await _service.disableTwoFactorAuth();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 