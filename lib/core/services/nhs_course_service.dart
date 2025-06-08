import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nhs_course_model.dart';

class NHSCourseService {
  final FirebaseFirestore _firestore;
  final String _collection = 'nhs_courses';

  NHSCourseService(this._firestore);

  Future<List<NHSCourseModel>> getCourses({
    required String userId,
    String? practiceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query =
        _firestore.collection(_collection).where('userId', isEqualTo: userId);

    if (practiceId != null) {
      query = query.where('practiceId', isEqualTo: practiceId);
    }

    if (startDate != null) {
      query = query.where('startDate', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('endDate', isLessThanOrEqualTo: endDate);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => NHSCourseModel.fromJson(
            {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  Future<NHSCourseModel?> getCourse(String courseId) async {
    final doc = await _firestore.collection(_collection).doc(courseId).get();
    if (!doc.exists) return null;
    return NHSCourseModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<String> createCourse(NHSCourseModel course) async {
    final docRef =
        await _firestore.collection(_collection).add(course.toJson());
    return docRef.id;
  }

  Future<void> updateCourse(String courseId, NHSCourseModel course) async {
    await _firestore
        .collection(_collection)
        .doc(courseId)
        .update(course.toJson());
  }

  Future<void> deleteCourse(String courseId) async {
    await _firestore.collection(_collection).doc(courseId).delete();
  }

  Future<Map<String, dynamic>> getMonthlyCourseStats({
    required String userId,
    required String practiceId,
    required DateTime month,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID is required');
    }

    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final courses = await getCourses(
        userId: userId,
        practiceId: practiceId,
        startDate: startDate,
        endDate: endDate,
      );

      double totalUdas = 0;
      double totalEarnings = 0;

      for (final course in courses) {
        totalUdas += course.udas;
        totalEarnings += course.udas * course.udaRate;
      }

      return {
        'totalCourses': courses.length,
        'totalUdas': totalUdas,
        'totalEarnings': totalEarnings,
      };
    } catch (e) {
      throw Exception('Failed to get monthly course stats: ${e.toString()}');
    }
  }
}
