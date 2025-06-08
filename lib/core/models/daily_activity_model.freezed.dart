// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyActivityModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get practiceId => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get nhsCourseId => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get dateOfService => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get entryTimestamp => throw _privateConstructorUsedError;
  @HiveField(6)
  String get patientInitials => throw _privateConstructorUsedError;
  @HiveField(7)
  String get patientAltCode => throw _privateConstructorUsedError;
  @HiveField(8)
  ActivityType get activityType => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get udasServiceDescription => throw _privateConstructorUsedError;
  @HiveField(10)
  double? get hygieneAppointmentFeeApplied =>
      throw _privateConstructorUsedError;
  @HiveField(11)
  double? get calculatedHygieneEarning => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get privateWorkDescription => throw _privateConstructorUsedError;
  @HiveField(13)
  double? get totalPatientChargePrivate => throw _privateConstructorUsedError;
  @HiveField(14)
  double? get privatePercentageApplied => throw _privateConstructorUsedError;
  @HiveField(15)
  double? get calculatedPrivateEarning => throw _privateConstructorUsedError;
  @HiveField(16)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(18)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyActivityModelCopyWith<DailyActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyActivityModelCopyWith<$Res> {
  factory $DailyActivityModelCopyWith(
          DailyActivityModel value, $Res Function(DailyActivityModel) then) =
      _$DailyActivityModelCopyWithImpl<$Res, DailyActivityModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String practiceId,
      @HiveField(3) String? nhsCourseId,
      @HiveField(4) DateTime dateOfService,
      @HiveField(5) DateTime entryTimestamp,
      @HiveField(6) String patientInitials,
      @HiveField(7) String patientAltCode,
      @HiveField(8) ActivityType activityType,
      @HiveField(9) String? udasServiceDescription,
      @HiveField(10) double? hygieneAppointmentFeeApplied,
      @HiveField(11) double? calculatedHygieneEarning,
      @HiveField(12) String? privateWorkDescription,
      @HiveField(13) double? totalPatientChargePrivate,
      @HiveField(14) double? privatePercentageApplied,
      @HiveField(15) double? calculatedPrivateEarning,
      @HiveField(16) String? notes,
      @HiveField(17) DateTime createdAt,
      @HiveField(18) DateTime updatedAt});
}

/// @nodoc
class _$DailyActivityModelCopyWithImpl<$Res, $Val extends DailyActivityModel>
    implements $DailyActivityModelCopyWith<$Res> {
  _$DailyActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? practiceId = null,
    Object? nhsCourseId = freezed,
    Object? dateOfService = null,
    Object? entryTimestamp = null,
    Object? patientInitials = null,
    Object? patientAltCode = null,
    Object? activityType = null,
    Object? udasServiceDescription = freezed,
    Object? hygieneAppointmentFeeApplied = freezed,
    Object? calculatedHygieneEarning = freezed,
    Object? privateWorkDescription = freezed,
    Object? totalPatientChargePrivate = freezed,
    Object? privatePercentageApplied = freezed,
    Object? calculatedPrivateEarning = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      practiceId: null == practiceId
          ? _value.practiceId
          : practiceId // ignore: cast_nullable_to_non_nullable
              as String,
      nhsCourseId: freezed == nhsCourseId
          ? _value.nhsCourseId
          : nhsCourseId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfService: null == dateOfService
          ? _value.dateOfService
          : dateOfService // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entryTimestamp: null == entryTimestamp
          ? _value.entryTimestamp
          : entryTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      patientInitials: null == patientInitials
          ? _value.patientInitials
          : patientInitials // ignore: cast_nullable_to_non_nullable
              as String,
      patientAltCode: null == patientAltCode
          ? _value.patientAltCode
          : patientAltCode // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      udasServiceDescription: freezed == udasServiceDescription
          ? _value.udasServiceDescription
          : udasServiceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      hygieneAppointmentFeeApplied: freezed == hygieneAppointmentFeeApplied
          ? _value.hygieneAppointmentFeeApplied
          : hygieneAppointmentFeeApplied // ignore: cast_nullable_to_non_nullable
              as double?,
      calculatedHygieneEarning: freezed == calculatedHygieneEarning
          ? _value.calculatedHygieneEarning
          : calculatedHygieneEarning // ignore: cast_nullable_to_non_nullable
              as double?,
      privateWorkDescription: freezed == privateWorkDescription
          ? _value.privateWorkDescription
          : privateWorkDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPatientChargePrivate: freezed == totalPatientChargePrivate
          ? _value.totalPatientChargePrivate
          : totalPatientChargePrivate // ignore: cast_nullable_to_non_nullable
              as double?,
      privatePercentageApplied: freezed == privatePercentageApplied
          ? _value.privatePercentageApplied
          : privatePercentageApplied // ignore: cast_nullable_to_non_nullable
              as double?,
      calculatedPrivateEarning: freezed == calculatedPrivateEarning
          ? _value.calculatedPrivateEarning
          : calculatedPrivateEarning // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyActivityModelImplCopyWith<$Res>
    implements $DailyActivityModelCopyWith<$Res> {
  factory _$$DailyActivityModelImplCopyWith(_$DailyActivityModelImpl value,
          $Res Function(_$DailyActivityModelImpl) then) =
      __$$DailyActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) String practiceId,
      @HiveField(3) String? nhsCourseId,
      @HiveField(4) DateTime dateOfService,
      @HiveField(5) DateTime entryTimestamp,
      @HiveField(6) String patientInitials,
      @HiveField(7) String patientAltCode,
      @HiveField(8) ActivityType activityType,
      @HiveField(9) String? udasServiceDescription,
      @HiveField(10) double? hygieneAppointmentFeeApplied,
      @HiveField(11) double? calculatedHygieneEarning,
      @HiveField(12) String? privateWorkDescription,
      @HiveField(13) double? totalPatientChargePrivate,
      @HiveField(14) double? privatePercentageApplied,
      @HiveField(15) double? calculatedPrivateEarning,
      @HiveField(16) String? notes,
      @HiveField(17) DateTime createdAt,
      @HiveField(18) DateTime updatedAt});
}

/// @nodoc
class __$$DailyActivityModelImplCopyWithImpl<$Res>
    extends _$DailyActivityModelCopyWithImpl<$Res, _$DailyActivityModelImpl>
    implements _$$DailyActivityModelImplCopyWith<$Res> {
  __$$DailyActivityModelImplCopyWithImpl(_$DailyActivityModelImpl _value,
      $Res Function(_$DailyActivityModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? practiceId = null,
    Object? nhsCourseId = freezed,
    Object? dateOfService = null,
    Object? entryTimestamp = null,
    Object? patientInitials = null,
    Object? patientAltCode = null,
    Object? activityType = null,
    Object? udasServiceDescription = freezed,
    Object? hygieneAppointmentFeeApplied = freezed,
    Object? calculatedHygieneEarning = freezed,
    Object? privateWorkDescription = freezed,
    Object? totalPatientChargePrivate = freezed,
    Object? privatePercentageApplied = freezed,
    Object? calculatedPrivateEarning = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DailyActivityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      practiceId: null == practiceId
          ? _value.practiceId
          : practiceId // ignore: cast_nullable_to_non_nullable
              as String,
      nhsCourseId: freezed == nhsCourseId
          ? _value.nhsCourseId
          : nhsCourseId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfService: null == dateOfService
          ? _value.dateOfService
          : dateOfService // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entryTimestamp: null == entryTimestamp
          ? _value.entryTimestamp
          : entryTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      patientInitials: null == patientInitials
          ? _value.patientInitials
          : patientInitials // ignore: cast_nullable_to_non_nullable
              as String,
      patientAltCode: null == patientAltCode
          ? _value.patientAltCode
          : patientAltCode // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      udasServiceDescription: freezed == udasServiceDescription
          ? _value.udasServiceDescription
          : udasServiceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      hygieneAppointmentFeeApplied: freezed == hygieneAppointmentFeeApplied
          ? _value.hygieneAppointmentFeeApplied
          : hygieneAppointmentFeeApplied // ignore: cast_nullable_to_non_nullable
              as double?,
      calculatedHygieneEarning: freezed == calculatedHygieneEarning
          ? _value.calculatedHygieneEarning
          : calculatedHygieneEarning // ignore: cast_nullable_to_non_nullable
              as double?,
      privateWorkDescription: freezed == privateWorkDescription
          ? _value.privateWorkDescription
          : privateWorkDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPatientChargePrivate: freezed == totalPatientChargePrivate
          ? _value.totalPatientChargePrivate
          : totalPatientChargePrivate // ignore: cast_nullable_to_non_nullable
              as double?,
      privatePercentageApplied: freezed == privatePercentageApplied
          ? _value.privatePercentageApplied
          : privatePercentageApplied // ignore: cast_nullable_to_non_nullable
              as double?,
      calculatedPrivateEarning: freezed == calculatedPrivateEarning
          ? _value.calculatedPrivateEarning
          : calculatedPrivateEarning // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$DailyActivityModelImpl implements _DailyActivityModel {
  const _$DailyActivityModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.userId,
      @HiveField(2) required this.practiceId,
      @HiveField(3) this.nhsCourseId,
      @HiveField(4) required this.dateOfService,
      @HiveField(5) required this.entryTimestamp,
      @HiveField(6) required this.patientInitials,
      @HiveField(7) required this.patientAltCode,
      @HiveField(8) required this.activityType,
      @HiveField(9) this.udasServiceDescription,
      @HiveField(10) this.hygieneAppointmentFeeApplied,
      @HiveField(11) this.calculatedHygieneEarning,
      @HiveField(12) this.privateWorkDescription,
      @HiveField(13) this.totalPatientChargePrivate,
      @HiveField(14) this.privatePercentageApplied,
      @HiveField(15) this.calculatedPrivateEarning,
      @HiveField(16) this.notes,
      @HiveField(17) required this.createdAt,
      @HiveField(18) required this.updatedAt});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String userId;
  @override
  @HiveField(2)
  final String practiceId;
  @override
  @HiveField(3)
  final String? nhsCourseId;
  @override
  @HiveField(4)
  final DateTime dateOfService;
  @override
  @HiveField(5)
  final DateTime entryTimestamp;
  @override
  @HiveField(6)
  final String patientInitials;
  @override
  @HiveField(7)
  final String patientAltCode;
  @override
  @HiveField(8)
  final ActivityType activityType;
  @override
  @HiveField(9)
  final String? udasServiceDescription;
  @override
  @HiveField(10)
  final double? hygieneAppointmentFeeApplied;
  @override
  @HiveField(11)
  final double? calculatedHygieneEarning;
  @override
  @HiveField(12)
  final String? privateWorkDescription;
  @override
  @HiveField(13)
  final double? totalPatientChargePrivate;
  @override
  @HiveField(14)
  final double? privatePercentageApplied;
  @override
  @HiveField(15)
  final double? calculatedPrivateEarning;
  @override
  @HiveField(16)
  final String? notes;
  @override
  @HiveField(17)
  final DateTime createdAt;
  @override
  @HiveField(18)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DailyActivityModel(id: $id, userId: $userId, practiceId: $practiceId, nhsCourseId: $nhsCourseId, dateOfService: $dateOfService, entryTimestamp: $entryTimestamp, patientInitials: $patientInitials, patientAltCode: $patientAltCode, activityType: $activityType, udasServiceDescription: $udasServiceDescription, hygieneAppointmentFeeApplied: $hygieneAppointmentFeeApplied, calculatedHygieneEarning: $calculatedHygieneEarning, privateWorkDescription: $privateWorkDescription, totalPatientChargePrivate: $totalPatientChargePrivate, privatePercentageApplied: $privatePercentageApplied, calculatedPrivateEarning: $calculatedPrivateEarning, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.practiceId, practiceId) ||
                other.practiceId == practiceId) &&
            (identical(other.nhsCourseId, nhsCourseId) ||
                other.nhsCourseId == nhsCourseId) &&
            (identical(other.dateOfService, dateOfService) ||
                other.dateOfService == dateOfService) &&
            (identical(other.entryTimestamp, entryTimestamp) ||
                other.entryTimestamp == entryTimestamp) &&
            (identical(other.patientInitials, patientInitials) ||
                other.patientInitials == patientInitials) &&
            (identical(other.patientAltCode, patientAltCode) ||
                other.patientAltCode == patientAltCode) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.udasServiceDescription, udasServiceDescription) ||
                other.udasServiceDescription == udasServiceDescription) &&
            (identical(other.hygieneAppointmentFeeApplied,
                    hygieneAppointmentFeeApplied) ||
                other.hygieneAppointmentFeeApplied ==
                    hygieneAppointmentFeeApplied) &&
            (identical(
                    other.calculatedHygieneEarning, calculatedHygieneEarning) ||
                other.calculatedHygieneEarning == calculatedHygieneEarning) &&
            (identical(other.privateWorkDescription, privateWorkDescription) ||
                other.privateWorkDescription == privateWorkDescription) &&
            (identical(other.totalPatientChargePrivate,
                    totalPatientChargePrivate) ||
                other.totalPatientChargePrivate == totalPatientChargePrivate) &&
            (identical(
                    other.privatePercentageApplied, privatePercentageApplied) ||
                other.privatePercentageApplied == privatePercentageApplied) &&
            (identical(
                    other.calculatedPrivateEarning, calculatedPrivateEarning) ||
                other.calculatedPrivateEarning == calculatedPrivateEarning) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        practiceId,
        nhsCourseId,
        dateOfService,
        entryTimestamp,
        patientInitials,
        patientAltCode,
        activityType,
        udasServiceDescription,
        hygieneAppointmentFeeApplied,
        calculatedHygieneEarning,
        privateWorkDescription,
        totalPatientChargePrivate,
        privatePercentageApplied,
        calculatedPrivateEarning,
        notes,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyActivityModelImplCopyWith<_$DailyActivityModelImpl> get copyWith =>
      __$$DailyActivityModelImplCopyWithImpl<_$DailyActivityModelImpl>(
          this, _$identity);
}

abstract class _DailyActivityModel implements DailyActivityModel {
  const factory _DailyActivityModel(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String userId,
          @HiveField(2) required final String practiceId,
          @HiveField(3) final String? nhsCourseId,
          @HiveField(4) required final DateTime dateOfService,
          @HiveField(5) required final DateTime entryTimestamp,
          @HiveField(6) required final String patientInitials,
          @HiveField(7) required final String patientAltCode,
          @HiveField(8) required final ActivityType activityType,
          @HiveField(9) final String? udasServiceDescription,
          @HiveField(10) final double? hygieneAppointmentFeeApplied,
          @HiveField(11) final double? calculatedHygieneEarning,
          @HiveField(12) final String? privateWorkDescription,
          @HiveField(13) final double? totalPatientChargePrivate,
          @HiveField(14) final double? privatePercentageApplied,
          @HiveField(15) final double? calculatedPrivateEarning,
          @HiveField(16) final String? notes,
          @HiveField(17) required final DateTime createdAt,
          @HiveField(18) required final DateTime updatedAt}) =
      _$DailyActivityModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get userId;
  @override
  @HiveField(2)
  String get practiceId;
  @override
  @HiveField(3)
  String? get nhsCourseId;
  @override
  @HiveField(4)
  DateTime get dateOfService;
  @override
  @HiveField(5)
  DateTime get entryTimestamp;
  @override
  @HiveField(6)
  String get patientInitials;
  @override
  @HiveField(7)
  String get patientAltCode;
  @override
  @HiveField(8)
  ActivityType get activityType;
  @override
  @HiveField(9)
  String? get udasServiceDescription;
  @override
  @HiveField(10)
  double? get hygieneAppointmentFeeApplied;
  @override
  @HiveField(11)
  double? get calculatedHygieneEarning;
  @override
  @HiveField(12)
  String? get privateWorkDescription;
  @override
  @HiveField(13)
  double? get totalPatientChargePrivate;
  @override
  @HiveField(14)
  double? get privatePercentageApplied;
  @override
  @HiveField(15)
  double? get calculatedPrivateEarning;
  @override
  @HiveField(16)
  String? get notes;
  @override
  @HiveField(17)
  DateTime get createdAt;
  @override
  @HiveField(18)
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$DailyActivityModelImplCopyWith<_$DailyActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
