// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyActivityModelAdapter extends TypeAdapter<DailyActivityModel> {
  @override
  final int typeId = 2;

  @override
  DailyActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyActivityModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      practiceId: fields[2] as String,
      nhsCourseId: fields[3] as String?,
      dateOfService: fields[4] as DateTime,
      entryTimestamp: fields[5] as DateTime,
      patientInitials: fields[6] as String,
      patientAltCode: fields[7] as String,
      activityType: fields[8] as ActivityType,
      udasServiceDescription: fields[9] as String?,
      hygieneAppointmentFeeApplied: fields[10] as double?,
      calculatedHygieneEarning: fields[11] as double?,
      privateWorkDescription: fields[12] as String?,
      totalPatientChargePrivate: fields[13] as double?,
      privatePercentageApplied: fields[14] as double?,
      calculatedPrivateEarning: fields[15] as double?,
      notes: fields[16] as String?,
      createdAt: fields[17] as DateTime,
      updatedAt: fields[18] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyActivityModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.practiceId)
      ..writeByte(3)
      ..write(obj.nhsCourseId)
      ..writeByte(4)
      ..write(obj.dateOfService)
      ..writeByte(5)
      ..write(obj.entryTimestamp)
      ..writeByte(6)
      ..write(obj.patientInitials)
      ..writeByte(7)
      ..write(obj.patientAltCode)
      ..writeByte(8)
      ..write(obj.activityType)
      ..writeByte(9)
      ..write(obj.udasServiceDescription)
      ..writeByte(10)
      ..write(obj.hygieneAppointmentFeeApplied)
      ..writeByte(11)
      ..write(obj.calculatedHygieneEarning)
      ..writeByte(12)
      ..write(obj.privateWorkDescription)
      ..writeByte(13)
      ..write(obj.totalPatientChargePrivate)
      ..writeByte(14)
      ..write(obj.privatePercentageApplied)
      ..writeByte(15)
      ..write(obj.calculatedPrivateEarning)
      ..writeByte(16)
      ..write(obj.notes)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 1;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.udaService;
      case 1:
        return ActivityType.hygiene;
      case 2:
        return ActivityType.private;
      default:
        return ActivityType.udaService;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.udaService:
        writer.writeByte(0);
        break;
      case ActivityType.hygiene:
        writer.writeByte(1);
        break;
      case ActivityType.private:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
