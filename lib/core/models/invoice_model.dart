import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

enum InvoiceStatus { draft, pending, paid, overdue, cancelled }

@HiveType(typeId: 1)
class InvoiceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String practiceId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String invoiceNumber;

  @HiveField(4)
  final DateTime invoiceDate;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime endDate;

  @HiveField(7)
  final int totalUdas;

  @HiveField(8)
  final double udaEarnings;

  @HiveField(9)
  final double hygieneEarnings;

  @HiveField(10)
  final double privateEarnings;

  @HiveField(11)
  final double totalEarnings;

  @HiveField(12)
  final String status;

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  InvoiceModel({
    required this.id,
    required this.practiceId,
    required this.userId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.startDate,
    required this.endDate,
    required this.totalUdas,
    required this.udaEarnings,
    required this.hygieneEarnings,
    required this.privateEarnings,
    required this.totalEarnings,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      practiceId: json['practiceId'] as String,
      userId: json['userId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceDate: (json['invoiceDate'] as Timestamp).toDate(),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      totalUdas: json['totalUdas'] as int,
      udaEarnings: (json['udaEarnings'] as num).toDouble(),
      hygieneEarnings: (json['hygieneEarnings'] as num).toDouble(),
      privateEarnings: (json['privateEarnings'] as num).toDouble(),
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'practiceId': practiceId,
      'userId': userId,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': Timestamp.fromDate(invoiceDate),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'totalUdas': totalUdas,
      'udaEarnings': udaEarnings,
      'hygieneEarnings': hygieneEarnings,
      'privateEarnings': privateEarnings,
      'totalEarnings': totalEarnings,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  InvoiceModel copyWith({
    String? id,
    String? practiceId,
    String? userId,
    String? invoiceNumber,
    DateTime? invoiceDate,
    DateTime? startDate,
    DateTime? endDate,
    int? totalUdas,
    double? udaEarnings,
    double? hygieneEarnings,
    double? privateEarnings,
    double? totalEarnings,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      practiceId: practiceId ?? this.practiceId,
      userId: userId ?? this.userId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalUdas: totalUdas ?? this.totalUdas,
      udaEarnings: udaEarnings ?? this.udaEarnings,
      hygieneEarnings: hygieneEarnings ?? this.hygieneEarnings,
      privateEarnings: privateEarnings ?? this.privateEarnings,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
