import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/practice_model.dart';
import '../services/practice_service.dart';

final practiceServiceProvider = Provider<PracticeService>((ref) {
  return PracticeService();
});

final practicesProvider = FutureProvider.family<List<PracticeModel>, String>((ref, userId) async {
  final practiceService = ref.watch(practiceServiceProvider);
  return await practiceService.getPractices(userId);
});

final selectedPracticeProvider = StateProvider<PracticeModel?>((ref) => null);

final practiceProvider = FutureProvider.family<PracticeModel, String>((ref, practiceId) async {
  final practiceService = ref.watch(practiceServiceProvider);
  return await practiceService.getPractice(practiceId);
}); 