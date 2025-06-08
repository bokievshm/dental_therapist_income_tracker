import 'package:hive/hive.dart';

part 'nhs_course_model.g.dart';

enum NHSCourseStatus {
  openBandIInitiated,
  closedBandIFinalised,
  closedBandIIFinalised,
}

@HiveType(typeId: 3)
class NHSCourseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String practiceId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String courseName;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final double totalHours;

  @HiveField(7)
  final double totalAmount;

  @HiveField(8)
  final String status;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  NHSCourseModel({
    required this.id,
    required this.practiceId,
    required this.userId,
    required this.courseName,
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.totalAmount,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NHSCourseModel.fromJson(Map<String, dynamic> json) {
    return NHSCourseModel(
      id: json['id'] as String,
      practiceId: json['practiceId'] as String,
      userId: json['userId'] as String,
      courseName: json['courseName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalHours: (json['totalHours'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'practiceId': practiceId,
      'userId': userId,
      'courseName': courseName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalHours': totalHours,
      'totalAmount': totalAmount,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  NHSCourseModel copyWith({
    String? id,
    String? practiceId,
    String? userId,
    String? courseName,
    DateTime? startDate,
    DateTime? endDate,
    double? totalHours,
    double? totalAmount,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NHSCourseModel(
      id: id ?? this.id,
      practiceId: practiceId ?? this.practiceId,
      userId: userId ?? this.userId,
      courseName: courseName ?? this.courseName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalHours: totalHours ?? this.totalHours,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
