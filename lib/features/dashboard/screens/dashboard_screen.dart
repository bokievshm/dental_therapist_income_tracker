import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/statistics_provider.dart';
import '../../../core/providers/practice_provider.dart';
import '../../../core/providers/auth_service_provider.dart';
import 'widgets/statistics_card.dart';
import 'widgets/earnings_chart.dart';
import 'widgets/practice_comparison_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();
  int _selectedYear = DateTime.now().year;
  String? _selectedPracticeId;

  @override
  Widget build(BuildContext context) {
    final practices = ref.watch(practicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _showDatePicker,
          ),
        ],
      ),
      body: practices.when(
        data: (practicesList) {
          if (practicesList.isEmpty) {
            return const Center(
              child: Text(
                  'No practices found. Add a practice to view statistics.'),
            );
          }

          // Set default selected practice if none is selected
          _selectedPracticeId ??= practicesList.first.id;

          final selectedPractice = practicesList.firstWhere(
            (p) => p.id == _selectedPracticeId,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPracticeSelector(practicesList),
                const SizedBox(height: 16),
                _buildMonthlyStatistics(selectedPractice),
                const SizedBox(height: 24),
                _buildYearlyStatistics(selectedPractice),
                const SizedBox(height: 24),
                _buildEarningsTrend(selectedPractice),
                const SizedBox(height: 24),
                _buildPracticeComparison(practicesList),
              ],
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

  Widget _buildPracticeSelector(List<PracticeModel> practices) {
    return DropdownButtonFormField<String>(
      value: _selectedPracticeId,
      decoration: const InputDecoration(
        labelText: 'Select Practice',
        border: OutlineInputBorder(),
      ),
      items: practices.map((practice) {
        return DropdownMenuItem(
          value: practice.id,
          child: Text(practice.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedPracticeId = value;
          });
        }
      },
    );
  }

  Widget _buildMonthlyStatistics(PracticeModel practice) {
    final stats = ref.watch(monthlyStatisticsProvider({
      'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
      'practiceId': practice.id,
      'month': _selectedMonth,
    }));

    return stats.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Statistics (${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'Total Earnings',
                  value: '£${data['totalEarnings'].toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCard(
                  title: 'Total UDAs',
                  value: data['totalUdas'].toString(),
                  icon: Icons.medical_services,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'Hygiene Earnings',
                  value: '£${data['hygieneEarnings'].toStringAsFixed(2)}',
                  icon: Icons.cleaning_services,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCard(
                  title: 'Private Earnings',
                  value: '£${data['privateEarnings'].toStringAsFixed(2)}',
                  icon: Icons.person,
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildYearlyStatistics(PracticeModel practice) {
    final stats = ref.watch(yearlyStatisticsProvider({
      'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
      'practiceId': practice.id,
      'year': _selectedYear,
    }));

    return stats.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yearly Statistics ($_selectedYear)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'Total Earnings',
                  value: '£${data['totalEarnings'].toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCard(
                  title: 'Monthly Average',
                  value: '£${data['yearlyAverageEarnings'].toStringAsFixed(2)}',
                  icon: Icons.calendar_month,
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildEarningsTrend(PracticeModel practice) {
    final trend = ref.watch(earningsTrendProvider({
      'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
      'practiceId': practice.id,
      'months': 6,
    }));

    return trend.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings Trend (Last 6 Months)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: EarningsChart(data: data),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildPracticeComparison(List<PracticeModel> practices) {
    final comparison = ref.watch(practiceComparisonProvider({
      'userId': ref.read(authServiceProvider).currentUser?.uid ?? '',
      'practices': practices,
      'month': _selectedMonth,
    }));

    return comparison.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Comparison (${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PracticeComparisonChart(data: data),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
        _selectedYear = picked.year;
      });
    }
  }
}
