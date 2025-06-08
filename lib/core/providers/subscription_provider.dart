import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

final subscriptionProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.getCurrentSubscription();
});

final subscriptionPlansProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.getSubscriptionPlans();
});

final subscriptionStateProvider = StateNotifierProvider<SubscriptionStateNotifier, AsyncValue<void>>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return SubscriptionStateNotifier(subscriptionService);
});

class SubscriptionStateNotifier extends StateNotifier<AsyncValue<void>> {
  final SubscriptionService _subscriptionService;

  SubscriptionStateNotifier(this._subscriptionService) : super(const AsyncValue.data(null));

  Future<void> subscribe(String planId) async {
    state = const AsyncValue.loading();
    try {
      await _subscriptionService.subscribe(planId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> cancelSubscription() async {
    state = const AsyncValue.loading();
    try {
      await _subscriptionService.cancelSubscription();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> changePlan(String newPlanId) async {
    state = const AsyncValue.loading();
    try {
      await _subscriptionService.changePlan(newPlanId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> renewSubscription() async {
    state = const AsyncValue.loading();
    try {
      await _subscriptionService.renewSubscription();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final featureAccessProvider = FutureProvider.family<bool, String>((ref, feature) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.hasFeatureAccess(feature);
});

final canCreateInvoiceProvider = FutureProvider<bool>((ref) async {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return await subscriptionService.canCreateInvoice();
});

final canAddMultiplePracticesProvider = FutureProvider<bool>((ref) async {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return await subscriptionService.canAddMultiplePractices();
}); 