import 'package:flutter/material.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final String currentStatus;
  final VoidCallback onSubscribe;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.currentStatus,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentPlan = plan['id'] == currentStatus;
    final isPremium = plan['id'] == 'premium';

    return Card(
      elevation: isPremium ? 4 : 2,
      child: Container(
        decoration: isPremium
            ? BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan['name'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'BEST VALUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan['price'] == 0
                    ? 'Free'
                    : '£${plan['price'].toStringAsFixed(2)}/month',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Features:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(plan['features'] as List<dynamic>).map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(feature as String),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan ? null : onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPremium
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isCurrentPlan
                        ? 'Current Plan'
                        : isPremium
                            ? 'Upgrade to Premium'
                            : 'Select Plan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 