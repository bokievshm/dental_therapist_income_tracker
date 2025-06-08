import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/daily_activity_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/daily_activity_provider.dart';
import 'activity_form_screen.dart';

class ActivityListScreen extends ConsumerStatefulWidget {
  final PracticeModel practice;

  const ActivityListScreen({
    super.key,
    required this.practice,
  });

  @override
  ConsumerState<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends ConsumerState<ActivityListScreen> {
  DateTime _selectedMonth = DateTime.now();
  ActivityType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider({
      'userId': 'current_user_id', // TODO: Replace with actual user ID
      'practiceId': widget.practice.id,
      'startDate': DateTime(_selectedMonth.year, _selectedMonth.month, 1),
      'endDate': DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0),
      'activityType': _selectedType,
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          Expanded(
            child: activities.when(
              data: (activitiesList) {
                if (activitiesList.isEmpty) {
                  return const Center(
                    child: Text('No activities found for this period'),
                  );
                }

                return ListView.builder(
                  itemCount: activitiesList.length,
                  itemBuilder: (context, index) {
                    final activity = activitiesList[index];
                    return _ActivityCard(
                      activity: activity,
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
              builder: (context) => ActivityFormScreen(
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

  Future<void> _showFilterDialog() async {
    final result = await showDialog<ActivityType?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Activities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Activities'),
              onTap: () => Navigator.pop(context, null),
            ),
            ...ActivityType.values.map(
              (type) => ListTile(
                title: Text(type.toString().split('.').last),
                onTap: () => Navigator.pop(context, type),
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedType = result;
      });
    }
  }
}

class _ActivityCard extends ConsumerWidget {
  final DailyActivityModel activity;
  final PracticeModel practice;

  const _ActivityCard({
    required this.activity,
    required this.practice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(activity.patientInitials),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${activity.dateOfService.toString().split(' ')[0]}'),
            Text('Type: ${activity.activityType.toString().split('.').last}'),
            if (activity.activityType == ActivityType.udaService)
              Text('Description: ${activity.udasServiceDescription}'),
            if (activity.activityType == ActivityType.hygiene)
              Text('Fee: £${activity.hygieneAppointmentFeeApplied}'),
            if (activity.activityType == ActivityType.private)
              Text('Charge: £${activity.totalPatientChargePrivate}'),
            if (activity.notes != null) Text('Notes: ${activity.notes}'),
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
                  builder: (context) => ActivityFormScreen(
                    activity: activity,
                    practice: practice,
                  ),
                ),
              );
            } else if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Activity'),
                  content: const Text(
                    'Are you sure you want to delete this activity? This action cannot be undone.',
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
                final activityService = ref.read(dailyActivityServiceProvider);
                await activityService.deleteActivity(activity.id);
                ref.invalidate(activitiesProvider);
              }
            }
          },
        ),
      ),
    );
  }
} 