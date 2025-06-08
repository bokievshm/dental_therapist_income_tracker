import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/invoice_provider.dart';
import '../../../core/providers/daily_activity_provider.dart';
import '../../../core/providers/nhs_course_provider.dart';
import '../../../core/providers/auth_service_provider.dart';

class InvoiceGenerateScreen extends ConsumerStatefulWidget {
  final PracticeModel practice;

  const InvoiceGenerateScreen({
    super.key,
    required this.practice,
  });

  @override
  ConsumerState<InvoiceGenerateScreen> createState() =>
      _InvoiceGenerateScreenState();
}

class _InvoiceGenerateScreenState extends ConsumerState<InvoiceGenerateScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate == null
                        ? 'Select Start Date'
                        : 'Start: ${_startDate!.toString().split(' ')[0]}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate == null
                        ? 'Select End Date'
                        : 'End: ${_endDate!.toString().split(' ')[0]}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startDate == null || _endDate == null
                  ? null
                  : () => _generateInvoice(context),
              child: const Text('Generate Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _generateInvoice(BuildContext context) async {
    if (_startDate == null || _endDate == null) return;

    try {
      // Get activities for the selected period
      final activities = await ref.read(activitiesProvider({
        'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
        'practiceId': widget.practice.id,
        'startDate': _startDate,
        'endDate': _endDate,
      }).future);

      // Get courses for the selected period
      final courses = await ref.read(nhsCoursesProvider({
        'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
        'practiceId': widget.practice.id,
        'startDate': _startDate,
        'endDate': _endDate,
      }).future);

      // Generate invoice
      final invoice = await ref.read(generateInvoiceProvider({
        'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
        'practice': widget.practice,
        'startDate': _startDate!,
        'endDate': _endDate!,
        'activities': activities,
        'courses': courses,
      }).future);

      if (mounted) {
        Navigator.pop(context, invoice);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating invoice: $e')),
        );
      }
    }
  }
}
