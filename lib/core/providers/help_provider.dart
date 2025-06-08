import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/help_service.dart';

final helpServiceProvider = Provider<HelpService>((ref) {
  return HelpService();
});

final faqsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(helpServiceProvider);
  return service.getFAQs();
});

final guidesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(helpServiceProvider);
  return service.getGuides();
});

final supportTicketsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(helpServiceProvider);
  return service.getSupportTickets();
});

final supportTicketProvider = StateNotifierProvider<SupportTicketNotifier, AsyncValue<void>>((ref) {
  return SupportTicketNotifier(ref.watch(helpServiceProvider));
});

class SupportTicketNotifier extends StateNotifier<AsyncValue<void>> {
  final HelpService _service;

  SupportTicketNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> submitTicket({
    required String subject,
    required String message,
    required String category,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.submitSupportTicket(
        subject: subject,
        message: message,
        category: category,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTicket({
    required String ticketId,
    required String message,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateSupportTicket(
        ticketId: ticketId,
        message: message,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 