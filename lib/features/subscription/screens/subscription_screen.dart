import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/subscription_provider.dart';
import '../widgets/subscription_plan_card.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);
    final subscriptionPlans = ref.watch(subscriptionPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: subscriptionStatus.when(
        data: (status) {
          return subscriptionPlans.when(
            data: (plans) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCurrentStatus(context, status),
                  const SizedBox(height: 24),
                  Text(
                    'Choose a Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ...plans.map((plan) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SubscriptionPlanCard(
                          plan: plan,
                          currentStatus: status['status'] as String,
                          onSubscribe: () => _handleSubscription(context, ref, plan),
                        ),
                      )),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context, Map<String, dynamic> status) {
    final statusText = status['status'] as String;
    final trialStartDate = status['trialStartDate'] as DateTime?;
    final trialEndDate = status['trialEndDate'] as DateTime?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusText(statusText),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getStatusColor(statusText),
                  ),
            ),
            if (statusText == 'free_trial' && trialEndDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Trial ends on ${_formatDate(trialEndDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'premium':
        return 'Premium Plan';
      case 'free_trial':
        return 'Free Trial';
      case 'free':
        return 'Free Plan';
      default:
        return 'Unknown Status';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'premium':
        return Colors.green;
      case 'free_trial':
        return Colors.orange;
      case 'free':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleSubscription(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> plan,
  ) async {
    // TODO: Implement payment processing
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'Payment processing will be implemented soon. This is just a placeholder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 