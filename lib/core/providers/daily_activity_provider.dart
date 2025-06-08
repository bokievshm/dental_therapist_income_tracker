import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_activity_model.dart';
import '../services/daily_activity_service.dart';

final dailyActivityServiceProvider = Provider<DailyActivityService>((ref) {
  return DailyActivityService();
});

final activitiesProvider = FutureProvider.family<List<DailyActivityModel>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(dailyActivityServiceProvider);
  return await service.getActivities(
    params['userId'] as String,
    practiceId: params['practiceId'] as String?,
    startDate: params['startDate'] as DateTime?,
    endDate: params['endDate'] as DateTime?,
    activityType: params['activityType'] as ActivityType?,
  );
});

final activityProvider = FutureProvider.family<DailyActivityModel, String>((ref, activityId) async {
  final service = ref.watch(dailyActivityServiceProvider);
  return await service.getActivity(activityId);
});

final monthlyEarningsProvider = FutureProvider.family<Map<String, double>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(dailyActivityServiceProvider);
  return await service.getMonthlyEarnings(
    params['userId'] as String,
    params['practiceId'] as String,
    params['month'] as DateTime,
  );
}); 