import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(FirebaseAnalytics.instance);
});

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> logError({
    required String error,
    String? stackTrace,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error',
        parameters: {
          'error': error,
          'stack_trace': stackTrace,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> setUserProperties({
    required String userId,
    String? userRole,
    String? userType,
  }) async {
    try {
      await _analytics.setUserId(id: userId);
      if (userRole != null) {
        await _analytics.setUserProperty(name: 'user_role', value: userRole);
      }
      if (userType != null) {
        await _analytics.setUserProperty(name: 'user_type', value: userType);
      }
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> logLogin({
    required String method,
    bool success = true,
    String? errorMessage,
  }) async {
    try {
      await _analytics.logLogin(
        loginMethod: method,
        success: success,
      );
      if (errorMessage != null) {
        await _analytics.logEvent(
          name: 'login_error',
          parameters: {
            'method': method,
            'error': errorMessage,
          },
        );
      }
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> logPracticeAction({
    required String action,
    required String practiceId,
    String? practiceName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'practice_action',
        parameters: {
          'action': action,
          'practice_id': practiceId,
          'practice_name': practiceName,
        },
      );
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }

  Future<void> logInvoiceAction({
    required String action,
    required String invoiceId,
    String? practiceId,
    double? amount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'invoice_action',
        parameters: {
          'action': action,
          'invoice_id': invoiceId,
          'practice_id': practiceId,
          'amount': amount,
        },
      );
    } catch (e) {
      // Silently fail in case of analytics errors
      print('Analytics error: $e');
    }
  }
}
