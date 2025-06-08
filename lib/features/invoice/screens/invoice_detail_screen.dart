import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/invoice_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/invoice_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final InvoiceModel invoice;
  final PracticeModel practice;

  const InvoiceDetailScreen({
    super.key,
    required this.invoice,
    required this.practice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.invoiceNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _generateAndSharePDF(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDetails(),
            const SizedBox(height: 24),
            _buildEarnings(),
            if (invoice.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              _buildNotes(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              practice.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(practice.address),
            Text('Email: ${practice.contactEmail}'),
            if (practice.managerName != null) Text('Manager: ${practice.managerName}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Invoice Number', invoice.invoiceNumber),
            _buildDetailRow('Date', invoice.invoiceDate.toString().split(' ')[0]),
            _buildDetailRow(
              'Period',
              '${invoice.startDate.toString().split(' ')[0]} - ${invoice.endDate.toString().split(' ')[0]}',
            ),
            _buildDetailRow('Status', invoice.status.toString().split('.').last),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earnings Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Total UDAs', invoice.totalUdas.toString()),
            _buildDetailRow('UDA Earnings', '£${invoice.udaEarnings.toStringAsFixed(2)}'),
            _buildDetailRow('Hygiene Earnings', '£${invoice.hygieneEarnings.toStringAsFixed(2)}'),
            _buildDetailRow('Private Earnings', '£${invoice.privateEarnings.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetailRow(
              'Total Earnings',
              '£${invoice.totalEarnings.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(invoice.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSharePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Text(
                  practice.name,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(practice.address),
                pw.Text('Email: ${practice.contactEmail}'),
                if (practice.managerName != null) pw.Text('Manager: ${practice.managerName}'),
                pw.SizedBox(height: 24),

                // Invoice Details
                pw.Text(
                  'Invoice Details',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildPDFDetailRow('Invoice Number', invoice.invoiceNumber),
                _buildPDFDetailRow('Date', invoice.invoiceDate.toString().split(' ')[0]),
                _buildPDFDetailRow(
                  'Period',
                  '${invoice.startDate.toString().split(' ')[0]} - ${invoice.endDate.toString().split(' ')[0]}',
                ),
                _buildPDFDetailRow('Status', invoice.status.toString().split('.').last),
                pw.SizedBox(height: 24),

                // Earnings Summary
                pw.Text(
                  'Earnings Summary',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildPDFDetailRow('Total UDAs', invoice.totalUdas.toString()),
                _buildPDFDetailRow('UDA Earnings', '£${invoice.udaEarnings.toStringAsFixed(2)}'),
                _buildPDFDetailRow('Hygiene Earnings', '£${invoice.hygieneEarnings.toStringAsFixed(2)}'),
                _buildPDFDetailRow('Private Earnings', '£${invoice.privateEarnings.toStringAsFixed(2)}'),
                pw.Divider(),
                _buildPDFDetailRow(
                  'Total Earnings',
                  '£${invoice.totalEarnings.toStringAsFixed(2)}',
                  isTotal: true,
                ),

                if (invoice.notes?.isNotEmpty == true) ...[
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Notes',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(invoice.notes!),
                ],
              ],
            );
          },
        ),
      );

      // Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/${invoice.invoiceNumber}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Invoice ${invoice.invoiceNumber}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  pw.Widget _buildPDFDetailRow(String label, String value, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 