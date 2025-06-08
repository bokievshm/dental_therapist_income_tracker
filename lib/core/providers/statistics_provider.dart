import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/practice_model.dart';
import '../services/statistics_service.dart';

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService(FirebaseFirestore.instance);
});

final monthlyStatisticsProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(statisticsServiceProvider);
  return service.getMonthlyStatistics(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String,
    month: params['month'] as DateTime,
  );
});

final yearlyStatisticsProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(statisticsServiceProvider);
  return service.getYearlyStatistics(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String,
    year: params['year'] as int,
  );
});

final practiceComparisonProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(statisticsServiceProvider);
  return service.getPracticeComparison(
    userId: params['userId'] as String,
    practices: params['practices'] as List<PracticeModel>,
    month: params['month'] as DateTime,
  );
});

final earningsTrendProvider = FutureProvider.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(statisticsServiceProvider);
  return service.getEarningsTrend(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String,
    months: params['months'] as int,
  );
}); 