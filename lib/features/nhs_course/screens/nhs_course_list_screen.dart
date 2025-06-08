import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/nhs_course_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/nhs_course_provider.dart';
import 'nhs_course_form_screen.dart';

class NHSCourseListScreen extends ConsumerStatefulWidget {
  final PracticeModel practice;

  const NHSCourseListScreen({
    super.key,
    required this.practice,
  });

  @override
  ConsumerState<NHSCourseListScreen> createState() => _NHSCourseListScreenState();
}

class _NHSCourseListScreenState extends ConsumerState<NHSCourseListScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(nhsCoursesProvider({
      'userId': 'current_user_id', // TODO: Replace with actual user ID
      'practiceId': widget.practice.id,
      'startDate': DateTime(_selectedMonth.year, _selectedMonth.month, 1),
      'endDate': DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0),
    }));

    final stats = ref.watch(monthlyCourseStatsProvider({
      'userId': 'current_user_id', // TODO: Replace with actual user ID
      'practiceId': widget.practice.id,
      'month': _selectedMonth,
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('NHS Courses'),
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          _buildStatsCard(stats),
          Expanded(
            child: courses.when(
              data: (coursesList) {
                if (coursesList.isEmpty) {
                  return const Center(
                    child: Text('No courses found for this period'),
                  );
                }

                return ListView.builder(
                  itemCount: coursesList.length,
                  itemBuilder: (context, index) {
                    final course = coursesList[index];
                    return _CourseCard(
                      course: course,
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
              builder: (context) => NHSCourseFormScreen(
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

  Widget _buildStatsCard(AsyncValue<Map<String, dynamic>> stats) {
    return stats.when(
      data: (data) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Monthly Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Courses', data['totalCourses'].toString()),
                  _buildStatItem('Total UDAs', data['totalUdas'].toString()),
                  _buildStatItem(
                    'Total Earnings',
                    '£${data['totalEarnings'].toStringAsFixed(2)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading stats: $error'),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _CourseCard extends ConsumerWidget {
  final NHSCourseModel course;
  final PracticeModel practice;

  const _CourseCard({
    required this.course,
    required this.practice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(course.patientInitials),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Period: ${course.startDate.toString().split(' ')[0]} - ${course.endDate.toString().split(' ')[0]}',
            ),
            Text('UDAs: ${course.udas}'),
            Text('Rate: £${course.udaRate}'),
            Text('Total: £${(course.udas * course.udaRate).toStringAsFixed(2)}'),
            if (course.notes != null) Text('Notes: ${course.notes}'),
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
                  builder: (context) => NHSCourseFormScreen(
                    course: course,
                    practice: practice,
                  ),
                ),
              );
            } else if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Course'),
                  content: const Text(
                    'Are you sure you want to delete this course? This action cannot be undone.',
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
                final courseService = ref.read(nhsCourseServiceProvider);
                await courseService.deleteCourse(course.id);
                ref.invalidate(nhsCoursesProvider);
              }
            }
          },
        ),
      ),
    );
  }
} 