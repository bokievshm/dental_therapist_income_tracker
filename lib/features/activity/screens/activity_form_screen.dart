import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/daily_activity_model.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/daily_activity_provider.dart';

class ActivityFormScreen extends ConsumerStatefulWidget {
  final DailyActivityModel? activity;
  final PracticeModel practice;

  const ActivityFormScreen({
    super.key,
    this.activity,
    required this.practice,
  });

  @override
  ConsumerState<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends ConsumerState<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _patientInitialsController;
  late TextEditingController _patientAltCodeController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  late ActivityType _selectedType;
  late TextEditingController _udaDescriptionController;
  late TextEditingController _hygieneFeeController;
  late TextEditingController _privateDescriptionController;
  late TextEditingController _privateChargeController;
  late TextEditingController _privatePercentageController;

  @override
  void initState() {
    super.initState();
    _patientInitialsController = TextEditingController(text: widget.activity?.patientInitials);
    _patientAltCodeController = TextEditingController(text: widget.activity?.patientAltCode);
    _notesController = TextEditingController(text: widget.activity?.notes);
    _selectedDate = widget.activity?.dateOfService ?? DateTime.now();
    _selectedType = widget.activity?.activityType ?? ActivityType.udaService;
    _udaDescriptionController = TextEditingController(text: widget.activity?.udasServiceDescription);
    _hygieneFeeController = TextEditingController(
      text: widget.activity?.hygieneAppointmentFeeApplied?.toString() ??
          widget.practice.defaultHygieneFee.toString(),
    );
    _privateDescriptionController = TextEditingController(text: widget.activity?.privateWorkDescription);
    _privateChargeController = TextEditingController(
      text: widget.activity?.totalPatientChargePrivate?.toString() ?? '0.0',
    );
    _privatePercentageController = TextEditingController(
      text: widget.activity?.privatePercentageApplied?.toString() ??
          widget.practice.defaultPrivatePercentage.toString(),
    );
  }

  @override
  void dispose() {
    _patientInitialsController.dispose();
    _patientAltCodeController.dispose();
    _notesController.dispose();
    _udaDescriptionController.dispose();
    _hygieneFeeController.dispose();
    _privateDescriptionController.dispose();
    _privateChargeController.dispose();
    _privatePercentageController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    final activityService = ref.read(dailyActivityServiceProvider);
    final activity = DailyActivityModel(
      id: widget.activity?.id ?? '',
      userId: 'current_user_id', // TODO: Replace with actual user ID
      practiceId: widget.practice.id,
      nhsCourseId: _selectedType == ActivityType.udaService ? null : widget.activity?.nhsCourseId,
      dateOfService: _selectedDate,
      entryTimestamp: DateTime.now(),
      patientInitials: _patientInitialsController.text,
      patientAltCode: _patientAltCodeController.text,
      activityType: _selectedType,
      udasServiceDescription: _selectedType == ActivityType.udaService ? _udaDescriptionController.text : null,
      hygieneAppointmentFeeApplied: _selectedType == ActivityType.hygiene
          ? double.parse(_hygieneFeeController.text)
          : null,
      calculatedHygieneEarning: _selectedType == ActivityType.hygiene
          ? double.parse(_hygieneFeeController.text)
          : null,
      privateWorkDescription: _selectedType == ActivityType.private
          ? _privateDescriptionController.text
          : null,
      totalPatientChargePrivate: _selectedType == ActivityType.private
          ? double.parse(_privateChargeController.text)
          : null,
      privatePercentageApplied: _selectedType == ActivityType.private
          ? double.parse(_privatePercentageController.text)
          : null,
      calculatedPrivateEarning: _selectedType == ActivityType.private
          ? double.parse(_privateChargeController.text) *
              (double.parse(_privatePercentageController.text) / 100)
          : null,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    try {
      if (widget.activity == null) {
        await activityService.createActivity(activity);
      } else {
        await activityService.updateActivity(activity);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving activity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity == null ? 'Add Activity' : 'Edit Activity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<ActivityType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Activity Type',
                border: OutlineInputBorder(),
              ),
              items: ActivityType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date of Service'),
              subtitle: Text(_selectedDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
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
            TextFormField(
              controller: _patientAltCodeController,
              decoration: const InputDecoration(
                labelText: 'Patient Alt Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter patient alt code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (_selectedType == ActivityType.udaService) ...[
              TextFormField(
                controller: _udaDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'UDA Service Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter UDA service description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            if (_selectedType == ActivityType.hygiene) ...[
              TextFormField(
                controller: _hygieneFeeController,
                decoration: const InputDecoration(
                  labelText: 'Hygiene Fee',
                  border: OutlineInputBorder(),
                  prefixText: '£',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hygiene fee';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            if (_selectedType == ActivityType.private) ...[
              TextFormField(
                controller: _privateDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Private Work Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter private work description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _privateChargeController,
                decoration: const InputDecoration(
                  labelText: 'Total Patient Charge',
                  border: OutlineInputBorder(),
                  prefixText: '£',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total patient charge';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _privatePercentageController,
                decoration: const InputDecoration(
                  labelText: 'Private Percentage',
                  border: OutlineInputBorder(),
                  suffixText: '%',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter private percentage';
                  }
                  final number = double.tryParse(value);
                  if (number == null) {
                    return 'Please enter a valid number';
                  }
                  if (number < 0 || number > 100) {
                    return 'Percentage must be between 0 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveActivity,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.activity == null ? 'Add Activity' : 'Save Changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 