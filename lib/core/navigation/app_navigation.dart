import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/practice/screens/practice_list_screen.dart';
import '../../features/activity/screens/activity_list_screen.dart';
import '../../features/nhs_course/screens/nhs_course_list_screen.dart';
import '../../features/invoice/screens/invoice_list_screen.dart';
import '../../features/subscription/screens/subscription_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class AppNavigation extends ConsumerWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          DashboardScreen(),
          PracticeListScreen(),
          ActivityListScreen(),
          NHSCourseListScreen(),
          InvoiceListScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Practices',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'NHS Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt),
            label: 'Invoices',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubscriptionScreen(),
            ),
          );
        },
        child: const Icon(Icons.star),
      ),
      appBar: AppBar(
        title: const Text('Dental Therapist Income Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 