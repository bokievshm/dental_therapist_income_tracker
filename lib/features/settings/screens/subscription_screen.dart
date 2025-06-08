import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/providers/auth_provider.dart';
import 'subscription_plans_screen.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final user = ref.watch(authProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: subscriptionState.when(
        data: (subscription) {
          if (subscription == null) {
            return _NoSubscriptionView();
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Current plan
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subscription.plan.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          _StatusChip(status: subscription.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valid until ${_formatDate(subscription.endDate)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (subscription.status == 'active') ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: _calculateProgress(subscription),
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_calculateDaysLeft(subscription)} days remaining',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Features
              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...subscription.plan.features.map((feature) => _FeatureTile(
                    icon: _getFeatureIcon(feature),
                    title: feature,
                  )),
              const SizedBox(height: 24),
              // Actions
              if (subscription.status == 'active') ...[
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement cancel subscription
                  },
                  child: const Text('Cancel Subscription'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionPlansScreen(),
                      ),
                    );
                  },
                  child: const Text('Change Plan'),
                ),
              ] else if (subscription.status == 'expired') ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionPlansScreen(),
                      ),
                    );
                  },
                  child: const Text('Renew Subscription'),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double _calculateProgress(Map<String, dynamic> subscription) {
    final startDate = subscription['startDate'] as DateTime;
    final endDate = subscription['endDate'] as DateTime;
    final totalDays = endDate.difference(startDate).inDays;
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    return 1 - (daysLeft / totalDays);
  }

  int _calculateDaysLeft(Map<String, dynamic> subscription) {
    final endDate = subscription['endDate'] as DateTime;
    return endDate.difference(DateTime.now()).inDays;
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'unlimited practices':
        return Icons.business;
      case 'unlimited nhs courses':
        return Icons.school;
      case 'invoice generation':
        return Icons.receipt;
      case 'statistics & reports':
        return Icons.bar_chart;
      case 'band ii reminders':
        return Icons.notifications;
      case 'priority support':
        return Icons.support_agent;
      default:
        return Icons.check_circle;
    }
  }
}

class _NoSubscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.card_membership,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Active Subscription',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Subscribe to unlock all features and manage your dental practice efficiently.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionPlansScreen(),
                  ),
                );
              },
              child: const Text('View Plans'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'expired':
        color = Colors.red;
        break;
      case 'cancelled':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.check, color: Colors.green),
    );
  }
} 