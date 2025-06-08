import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/invoice_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/invoice_provider.dart';
import 'invoice_detail_screen.dart';
import 'invoice_generate_screen.dart';

class InvoiceListScreen extends ConsumerStatefulWidget {
  final PracticeModel practice;

  const InvoiceListScreen({
    super.key,
    required this.practice,
  });

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoicesProvider({
      'userId': 'current_user_id', // TODO: Replace with actual user ID
      'practiceId': widget.practice.id,
      'startDate': DateTime(_selectedMonth.year, _selectedMonth.month, 1),
      'endDate': DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0),
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          Expanded(
            child: invoices.when(
              data: (invoicesList) {
                if (invoicesList.isEmpty) {
                  return const Center(
                    child: Text('No invoices found for this period'),
                  );
                }

                return ListView.builder(
                  itemCount: invoicesList.length,
                  itemBuilder: (context, index) {
                    final invoice = invoicesList[index];
                    return _InvoiceCard(
                      invoice: invoice,
                      practice: widget.practice,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceGenerateScreen(
                practice: widget.practice,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              });
            },
          ),
          Text(
            '${_selectedMonth.year} - ${_selectedMonth.month.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends ConsumerWidget {
  final InvoiceModel invoice;
  final PracticeModel practice;

  const _InvoiceCard({
    required this.invoice,
    required this.practice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(invoice.invoiceNumber),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${invoice.invoiceDate.toString().split(' ')[0]}'),
            Text('Period: ${invoice.startDate.toString().split(' ')[0]} - ${invoice.endDate.toString().split(' ')[0]}'),
            Text('Status: ${invoice.status.toString().split('.').last}'),
            Text('Total: £${invoice.totalEarnings.toStringAsFixed(2)}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Text('View Details'),
            ),
            if (invoice.status == InvoiceStatus.draft) ...[
              const PopupMenuItem(
                value: 'mark_paid',
                child: Text('Mark as Paid'),
              ),
              const PopupMenuItem(
                value: 'mark_overdue',
                child: Text('Mark as Overdue'),
              ),
            ],
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) async {
            if (value == 'view') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceDetailScreen(
                    invoice: invoice,
                    practice: practice,
                  ),
                ),
              );
            } else if (value == 'mark_paid') {
              final service = ref.read(invoiceServiceProvider);
              await service.markInvoiceAsPaid(invoice.id);
              ref.invalidate(invoicesProvider);
            } else if (value == 'mark_overdue') {
              final service = ref.read(invoiceServiceProvider);
              await service.markInvoiceAsOverdue(invoice.id);
              ref.invalidate(invoicesProvider);
            } else if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Invoice'),
                  content: const Text(
                    'Are you sure you want to delete this invoice? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final service = ref.read(invoiceServiceProvider);
                await service.deleteInvoice(invoice.id);
                ref.invalidate(invoicesProvider);
              }
            }
          },
        ),
      ),
    );
  }
} 