import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/nhs_course_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/nhs_course_provider.dart';

class NHSCourseFormScreen extends ConsumerStatefulWidget {
  final NHSCourseModel? course;
  final PracticeModel practice;

  const NHSCourseFormScreen({
    super.key,
    this.course,
    required this.practice,
  });

  @override
  ConsumerState<NHSCourseFormScreen> createState() => _NHSCourseFormScreenState();
}

class _NHSCourseFormScreenState extends ConsumerState<NHSCourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _patientInitialsController;
  late TextEditingController _udasController;
  late TextEditingController _udaRateController;
  late TextEditingController _notesController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _patientInitialsController = TextEditingController(text: widget.course?.patientInitials);
    _udasController = TextEditingController(text: widget.course?.udas.toString());
    _udaRateController = TextEditingController(text: widget.course?.udaRate.toString());
    _notesController = TextEditingController(text: widget.course?.notes);
    _startDate = widget.course?.startDate;
    _endDate = widget.course?.endDate;
  }

  @override
  void dispose() {
    _patientInitialsController.dispose();
    _udasController.dispose();
    _udaRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    final course = NHSCourseModel(
      id: widget.course?.id ?? '',
      userId: 'current_user_id', // TODO: Replace with actual user ID
      practiceId: widget.practice.id,
      patientInitials: _patientInitialsController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      udas: double.parse(_udasController.text),
      udaRate: double.parse(_udaRateController.text),
      notes: _notesController.text,
    );

    try {
      final service = ref.read(nhsCourseServiceProvider);
      if (widget.course == null) {
        await service.createCourse(course);
      } else {
        await service.updateCourse(course.id, course);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving course: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Add NHS Course' : 'Edit NHS Course'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _patientInitialsController,
              decoration: const InputDecoration(
                labelText: 'Patient Initials',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter patient initials';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate == null
                        ? 'Select Start Date'
                        : 'Start: ${_startDate!.toString().split(' ')[0]}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate == null
                        ? 'Select End Date'
                        : 'End: ${_endDate!.toString().split(' ')[0]}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _udasController,
              decoration: const InputDecoration(
                labelText: 'Number of UDAs',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of UDAs';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _udaRateController,
              decoration: const InputDecoration(
                labelText: 'UDA Rate (£)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter UDA rate';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCourse,
              child: Text(widget.course == null ? 'Add Course' : 'Update Course'),
            ),
          ],
        ),
      ),
    );
  }
} 