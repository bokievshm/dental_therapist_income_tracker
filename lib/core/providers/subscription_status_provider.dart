import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';

final subscriptionStatusProvider = StateNotifierProvider<SubscriptionStatusNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return SubscriptionStatusNotifier(ref.watch(subscriptionServiceProvider));
});

class SubscriptionStatusNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final SubscriptionService _subscriptionService;

  SubscriptionStatusNotifier(this._subscriptionService) : super(const AsyncValue.loading()) {
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    try {
      final status = await _subscriptionService.getCurrentSubscription();
      state = AsyncValue.data(status);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadSubscriptionStatus();
  }
} 