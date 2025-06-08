import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_activity_model.dart';
import '../models/nhs_course_model.dart';
import '../models/practice_model.dart';

class StatisticsService {
  final FirebaseFirestore _firestore;

  StatisticsService(this._firestore);

  Future<Map<String, dynamic>> getMonthlyStatistics({
    required String userId,
    required String practiceId,
    required DateTime month,
  }) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    // Get activities
    final activitiesSnapshot = await _firestore
        .collection('daily_activities')
        .where('userId', isEqualTo: userId)
        .where('practiceId', isEqualTo: practiceId)
        .where('dateOfService', isGreaterThanOrEqualTo: startDate)
        .where('dateOfService', isLessThanOrEqualTo: endDate)
        .get();

    final activities = activitiesSnapshot.docs
        .map((doc) => DailyActivityModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    // Get courses
    final coursesSnapshot = await _firestore
        .collection('nhs_courses')
        .where('userId', isEqualTo: userId)
        .where('practiceId', isEqualTo: practiceId)
        .where('startDate', isLessThanOrEqualTo: endDate)
        .where('endDate', isGreaterThanOrEqualTo: startDate)
        .get();

    final courses = coursesSnapshot.docs
        .map((doc) => NHSCourseModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    // Calculate statistics
    double totalUdas = 0;
    double udaEarnings = 0;
    double hygieneEarnings = 0;
    double privateEarnings = 0;
    int hygieneAppointments = 0;
    int privateAppointments = 0;

    // Process courses
    for (final course in courses) {
      totalUdas += course.udas;
      udaEarnings += course.udas * course.udaRate;
    }

    // Process activities
    for (final activity in activities) {
      switch (activity.activityType) {
        case ActivityType.hygiene:
          hygieneEarnings += activity.hygieneAppointmentFeeApplied;
          hygieneAppointments++;
          break;
        case ActivityType.private:
          privateEarnings += activity.totalPatientChargePrivate;
          privateAppointments++;
          break;
        default:
          break;
      }
    }

    final totalEarnings = udaEarnings + hygieneEarnings + privateEarnings;
    final totalAppointments = hygieneAppointments + privateAppointments;

    // Calculate daily averages
    final daysInMonth = endDate.day;
    final dailyAverageEarnings = totalEarnings / daysInMonth;
    final dailyAverageAppointments = totalAppointments / daysInMonth;

    return {
      'totalUdas': totalUdas,
      'udaEarnings': udaEarnings,
      'hygieneEarnings': hygieneEarnings,
      'privateEarnings': privateEarnings,
      'totalEarnings': totalEarnings,
      'hygieneAppointments': hygieneAppointments,
      'privateAppointments': privateAppointments,
      'totalAppointments': totalAppointments,
      'dailyAverageEarnings': dailyAverageEarnings,
      'dailyAverageAppointments': dailyAverageAppointments,
    };
  }

  Future<Map<String, dynamic>> getYearlyStatistics({
    required String userId,
    required String practiceId,
    required int year,
  }) async {
    final monthlyStats = <Map<String, dynamic>>[];
    double totalUdas = 0;
    double totalEarnings = 0;
    int totalAppointments = 0;

    // Get statistics for each month
    for (int month = 1; month <= 12; month++) {
      final stats = await getMonthlyStatistics(
        userId: userId,
        practiceId: practiceId,
        month: DateTime(year, month),
      );
      monthlyStats.add(stats);

      totalUdas += stats['totalUdas'] as double;
      totalEarnings += stats['totalEarnings'] as double;
      totalAppointments += stats['totalAppointments'] as int;
    }

    // Calculate yearly averages
    final yearlyAverageEarnings = totalEarnings / 12;
    final yearlyAverageAppointments = totalAppointments / 12;

    return {
      'monthlyStats': monthlyStats,
      'totalUdas': totalUdas,
      'totalEarnings': totalEarnings,
      'totalAppointments': totalAppointments,
      'yearlyAverageEarnings': yearlyAverageEarnings,
      'yearlyAverageAppointments': yearlyAverageAppointments,
    };
  }

  Future<Map<String, dynamic>> getPracticeComparison({
    required String userId,
    required List<PracticeModel> practices,
    required DateTime month,
  }) async {
    final practiceStats = <Map<String, dynamic>>[];

    for (final practice in practices) {
      final stats = await getMonthlyStatistics(
        userId: userId,
        practiceId: practice.id,
        month: month,
      );

      practiceStats.add({
        'practiceId': practice.id,
        'practiceName': practice.name,
        'stats': stats,
      });
    }

    return {
      'practiceStats': practiceStats,
      'month': month,
    };
  }

  Future<List<Map<String, dynamic>>> getEarningsTrend({
    required String userId,
    required String practiceId,
    required int months,
  }) async {
    final trend = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final stats = await getMonthlyStatistics(
        userId: userId,
        practiceId: practiceId,
        month: month,
      );

      trend.add({
        'month': month,
        'stats': stats,
      });
    }

    return trend;
  }
} 