import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'daily_activity_model.g.dart';
part 'daily_activity_model.freezed.dart';

@HiveType(typeId: 1)
enum ActivityType {
  @HiveField(0)
  udaService,
  @HiveField(1)
  hygiene,
  @HiveField(2)
  private,
}

@freezed
@HiveType(typeId: 2)
class DailyActivityModel with _$DailyActivityModel {
  const factory DailyActivityModel({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required String practiceId,
    @HiveField(3) String? nhsCourseId,
    @HiveField(4) required DateTime dateOfService,
    @HiveField(5) required DateTime entryTimestamp,
    @HiveField(6) required String patientInitials,
    @HiveField(7) required String patientAltCode,
    @HiveField(8) required ActivityType activityType,
    @HiveField(9) String? udasServiceDescription,
    @HiveField(10) double? hygieneAppointmentFeeApplied,
    @HiveField(11) double? calculatedHygieneEarning,
    @HiveField(12) String? privateWorkDescription,
    @HiveField(13) double? totalPatientChargePrivate,
    @HiveField(14) double? privatePercentageApplied,
    @HiveField(15) double? calculatedPrivateEarning,
    @HiveField(16) String? notes,
    @HiveField(17) required DateTime createdAt,
    @HiveField(18) required DateTime updatedAt,
  }) = _DailyActivityModel;

  factory DailyActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyActivityModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      practiceId: data['practiceId'] ?? '',
      nhsCourseId: data['nhsCourseId'],
      dateOfService: (data['dateOfService'] as Timestamp).toDate(),
      entryTimestamp: (data['entryTimestamp'] as Timestamp).toDate(),
      patientInitials: data['patientInitials'] ?? '',
      patientAltCode: data['patientAltCode'] ?? '',
      activityType: ActivityType.values.firstWhere(
        (e) => e.toString() == 'ActivityType.${data['activityType']}',
        orElse: () => ActivityType.udaService,
      ),
      udasServiceDescription: data['udasServiceDescription'],
      hygieneAppointmentFeeApplied:
          data['hygieneAppointmentFeeApplied']?.toDouble(),
      calculatedHygieneEarning: data['calculatedHygieneEarning']?.toDouble(),
      privateWorkDescription: data['privateWorkDescription'],
      totalPatientChargePrivate: data['totalPatientChargePrivate']?.toDouble(),
      privatePercentageApplied: data['privatePercentageApplied']?.toDouble(),
      calculatedPrivateEarning: data['calculatedPrivateEarning']?.toDouble(),
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'practiceId': practiceId,
      'nhsCourseId': nhsCourseId,
      'dateOfService': Timestamp.fromDate(dateOfService),
      'entryTimestamp': Timestamp.fromDate(entryTimestamp),
      'patientInitials': patientInitials,
      'patientAltCode': patientAltCode,
      'activityType': activityType.toString().split('.').last,
      'udasServiceDescription': udasServiceDescription,
      'hygieneAppointmentFeeApplied': hygieneAppointmentFeeApplied,
      'calculatedHygieneEarning': calculatedHygieneEarning,
      'privateWorkDescription': privateWorkDescription,
      'totalPatientChargePrivate': totalPatientChargePrivate,
      'privatePercentageApplied': privatePercentageApplied,
      'calculatedPrivateEarning': calculatedPrivateEarning,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
