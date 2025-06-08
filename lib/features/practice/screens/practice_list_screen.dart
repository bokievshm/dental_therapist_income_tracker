import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/practice_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../shared/widgets/subscription_status_widget.dart';
import 'practice_form_screen.dart';

class PracticeListScreen extends ConsumerWidget {
  const PracticeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practices = ref.watch(practicesProvider('current_user_id')); // TODO: Replace with actual user ID
    final canAddMultiple = ref.watch(canAddMultiplePracticesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Practices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SubscriptionStatusWidget(),
          Expanded(
            child: practices.when(
              data: (practicesList) {
                if (practicesList.isEmpty) {
                  return const Center(
                    child: Text('No practices added yet'),
                  );
                }

                return ListView.builder(
                  itemCount: practicesList.length,
                  itemBuilder: (context, index) {
                    final practice = practicesList[index];
                    return _PracticeCard(practice: practice);
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
      floatingActionButton: canAddMultiple.when(
        data: (canAdd) {
          if (!canAdd && practices.value?.isNotEmpty == true) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PracticeFormScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _PracticeCard extends ConsumerWidget {
  final PracticeModel practice;

  const _PracticeCard({required this.practice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(practice.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(practice.address),
            Text('Manager: ${practice.practiceManagerName}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PracticeFormScreen(practice: practice),
                ),
              );
            } else if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Practice'),
                  content: const Text(
                    'Are you sure you want to delete this practice? This action cannot be undone.',
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
                final practiceService = ref.read(practiceServiceProvider);
                await practiceService.deletePractice(practice.id);
                ref.invalidate(practicesProvider);
              }
            }
          },
        ),
        onTap: () {
          ref.read(selectedPracticeProvider.notifier).state = practice;
          // TODO: Navigate to practice details
        },
      ),
    );
  }
} 