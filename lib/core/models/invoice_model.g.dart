// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 1;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      id: fields[0] as String,
      practiceId: fields[1] as String,
      userId: fields[2] as String,
      invoiceNumber: fields[3] as String,
      invoiceDate: fields[4] as DateTime,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime,
      totalUdas: fields[7] as int,
      udaEarnings: fields[8] as double,
      hygieneEarnings: fields[9] as double,
      privateEarnings: fields[10] as double,
      totalEarnings: fields[11] as double,
      status: fields[12] as String,
      notes: fields[13] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.practiceId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.invoiceNumber)
      ..writeByte(4)
      ..write(obj.invoiceDate)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.totalUdas)
      ..writeByte(8)
      ..write(obj.udaEarnings)
      ..writeByte(9)
      ..write(obj.hygieneEarnings)
      ..writeByte(10)
      ..write(obj.privateEarnings)
      ..writeByte(11)
      ..write(obj.totalEarnings)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
