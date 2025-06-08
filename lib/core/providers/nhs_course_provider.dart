import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nhs_course_model.dart';
import '../services/nhs_course_service.dart';

final nhsCourseServiceProvider = Provider<NHSCourseService>((ref) {
  return NHSCourseService(FirebaseFirestore.instance);
});

final nhsCoursesProvider = FutureProvider.family<List<NHSCourseModel>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(nhsCourseServiceProvider);
  return service.getCourses(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String?,
    startDate: params['startDate'] as DateTime?,
    endDate: params['endDate'] as DateTime?,
  );
});

final nhsCourseProvider = FutureProvider.family<NHSCourseModel?, String>((ref, courseId) {
  final service = ref.watch(nhsCourseServiceProvider);
  return service.getCourse(courseId);
});

final monthlyCourseStatsProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(nhsCourseServiceProvider);
  return service.getMonthlyCourseStats(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String,
    month: params['month'] as DateTime,
  );
}); 