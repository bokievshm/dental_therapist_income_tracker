import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_activity_model.dart';

class DailyActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'daily_activities';

  Future<List<DailyActivityModel>> getActivities(
    String userId, {
    String? practiceId,
    DateTime? startDate,
    DateTime? endDate,
    ActivityType? activityType,
  }) async {
    Query query = _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId);

    if (practiceId != null) {
      query = query.where('practiceId', isEqualTo: practiceId);
    }

    if (startDate != null) {
      query = query.where('dateOfService', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('dateOfService', isLessThanOrEqualTo: endDate);
    }

    if (activityType != null) {
      query = query.where('activityType', isEqualTo: activityType.toString().split('.').last);
    }

    final snapshot = await query.orderBy('dateOfService', descending: true).get();

    return snapshot.docs
        .map((doc) => DailyActivityModel.fromFirestore(doc))
        .toList();
  }

  Future<DailyActivityModel> getActivity(String activityId) async {
    final doc = await _firestore.collection(_collection).doc(activityId).get();
    return DailyActivityModel.fromFirestore(doc);
  }

  Future<String> createActivity(DailyActivityModel activity) async {
    final docRef = await _firestore.collection(_collection).add(activity.toFirestore());
    return docRef.id;
  }

  Future<void> updateActivity(DailyActivityModel activity) async {
    await _firestore
        .collection(_collection)
        .doc(activity.id)
        .update(activity.toFirestore());
  }

  Future<void> deleteActivity(String activityId) async {
    await _firestore.collection(_collection).doc(activityId).delete();
  }

  Future<Map<String, double>> getMonthlyEarnings(
    String userId,
    String practiceId,
    DateTime month,
  ) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    final activities = await getActivities(
      userId,
      practiceId: practiceId,
      startDate: startDate,
      endDate: endDate,
    );

    double udaEarnings = 0;
    double hygieneEarnings = 0;
    double privateEarnings = 0;

    for (final activity in activities) {
      switch (activity.activityType) {
        case ActivityType.udaService:
          // UDA earnings are calculated when the course is closed
          break;
        case ActivityType.hygiene:
          hygieneEarnings += activity.calculatedHygieneEarning ?? 0;
          break;
        case ActivityType.private:
          privateEarnings += activity.calculatedPrivateEarning ?? 0;
          break;
      }
    }

    return {
      'uda': udaEarnings,
      'hygiene': hygieneEarnings,
      'private': privateEarnings,
      'total': udaEarnings + hygieneEarnings + privateEarnings,
    };
  }
} 