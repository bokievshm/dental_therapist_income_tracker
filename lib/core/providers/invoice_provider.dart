import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice_model.dart';
import '../models/practice_model.dart';
import '../models/daily_activity_model.dart';
import '../models/nhs_course_model.dart';
import '../services/invoice_service.dart';

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  return InvoiceService(FirebaseFirestore.instance);
});

final invoicesProvider = FutureProvider.family<List<InvoiceModel>, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(invoiceServiceProvider);
  return service.getInvoices(
    userId: params['userId'] as String,
    practiceId: params['practiceId'] as String?,
    startDate: params['startDate'] as DateTime?,
    endDate: params['endDate'] as DateTime?,
  );
});

final invoiceProvider = FutureProvider.family<InvoiceModel?, String>((ref, invoiceId) {
  final service = ref.watch(invoiceServiceProvider);
  return service.getInvoice(invoiceId);
});

final generateInvoiceProvider = FutureProvider.family<InvoiceModel, Map<String, dynamic>>((ref, params) {
  final service = ref.watch(invoiceServiceProvider);
  return service.generateInvoice(
    userId: params['userId'] as String,
    practice: params['practice'] as PracticeModel,
    startDate: params['startDate'] as DateTime,
    endDate: params['endDate'] as DateTime,
    activities: params['activities'] as List<DailyActivityModel>,
    courses: params['courses'] as List<NHSCourseModel>,
  );
}); 