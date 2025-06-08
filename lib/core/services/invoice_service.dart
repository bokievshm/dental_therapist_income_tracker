import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_model.dart';
import '../models/practice_model.dart';
import '../models/daily_activity_model.dart';
import '../models/nhs_course_model.dart';

class InvoiceService {
  final FirebaseFirestore _firestore;
  final String _collection = 'invoices';

  InvoiceService(this._firestore);

  Future<List<InvoiceModel>> getInvoices({
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
      query = query.where('invoiceDate', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('invoiceDate', isLessThanOrEqualTo: endDate);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => InvoiceModel.fromJson(
            {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  Future<InvoiceModel?> getInvoice(String invoiceId) async {
    final doc = await _firestore.collection(_collection).doc(invoiceId).get();
    if (!doc.exists) return null;
    return InvoiceModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<String> createInvoice(InvoiceModel invoice) async {
    final docRef =
        await _firestore.collection(_collection).add(invoice.toJson());
    return docRef.id;
  }

  Future<void> updateInvoice(String invoiceId, InvoiceModel invoice) async {
    await _firestore
        .collection(_collection)
        .doc(invoiceId)
        .update(invoice.toJson());
  }

  Future<void> deleteInvoice(String invoiceId) async {
    await _firestore.collection(_collection).doc(invoiceId).delete();
  }

  Future<InvoiceModel> generateInvoice({
    required String userId,
    required PracticeModel practice,
    required DateTime startDate,
    required DateTime endDate,
    required List<DailyActivityModel> activities,
    required List<NHSCourseModel> courses,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID is required');
    }
    if (startDate.isAfter(endDate)) {
      throw Exception('Start date must be before end date');
    }

    try {
      // Calculate UDA earnings
      double totalUdas = 0;
      double udaEarnings = 0;
      for (final course in courses) {
        if (course.startDate.isAfter(startDate) &&
            course.endDate.isBefore(endDate)) {
          totalUdas += course.udas;
          udaEarnings += course.udas * (course.udaRate ?? 0);
        }
      }

      // Calculate hygiene earnings
      double hygieneEarnings = 0;
      for (final activity in activities) {
        if (activity.activityType == ActivityType.hygiene &&
            activity.dateOfService.isAfter(startDate) &&
            activity.dateOfService.isBefore(endDate)) {
          hygieneEarnings += activity.hygieneAppointmentFeeApplied ?? 0;
        }
      }

      // Calculate private earnings
      double privateEarnings = 0;
      for (final activity in activities) {
        if (activity.activityType == ActivityType.private &&
            activity.dateOfService.isAfter(startDate) &&
            activity.dateOfService.isBefore(endDate)) {
          privateEarnings += activity.totalPatientChargePrivate ?? 0;
        }
      }

      // Calculate total earnings
      final totalEarnings = udaEarnings + hygieneEarnings + privateEarnings;

      // Create invoice
      final invoice = InvoiceModel(
        id: '',
        userId: userId,
        practiceId: practice.id,
        invoiceNumber: await _generateInvoiceNumber(),
        invoiceDate: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        totalUdas: totalUdas,
        udaEarnings: udaEarnings,
        hygieneEarnings: hygieneEarnings,
        privateEarnings: privateEarnings,
        totalEarnings: totalEarnings,
        status: InvoiceStatus.draft,
        notes: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return invoice;
    } catch (e) {
      throw Exception('Failed to generate invoice: ${e.toString()}');
    }
  }

  Future<String> _generateInvoiceNumber() async {
    final year = DateTime.now().year;
    final month = DateTime.now().month.toString().padLeft(2, '0');

    // Get the last invoice number for this month
    final query = await _firestore
        .collection(_collection)
        .where('invoiceNumber', isGreaterThanOrEqualTo: 'INV-$year$month-')
        .orderBy('invoiceNumber', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return 'INV-$year$month-001';
    }

    final lastNumber = query.docs.first.data()['invoiceNumber'] as String;
    final lastSequence = int.parse(lastNumber.split('-').last);
    final newSequence = (lastSequence + 1).toString().padLeft(3, '0');
    return 'INV-$year$month-$newSequence';
  }

  Future<void> markInvoiceAsPaid(String invoiceId) async {
    await _firestore.collection(_collection).doc(invoiceId).update({
      'status': InvoiceStatus.paid.toString(),
    });
  }

  Future<void> markInvoiceAsOverdue(String invoiceId) async {
    await _firestore.collection(_collection).doc(invoiceId).update({
      'status': InvoiceStatus.overdue.toString(),
    });
  }
}
