import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/practice_model.dart';
import '../../../core/providers/practice_provider.dart';

class PracticeFormScreen extends ConsumerStatefulWidget {
  final PracticeModel? practice;

  const PracticeFormScreen({super.key, this.practice});

  @override
  ConsumerState<PracticeFormScreen> createState() => _PracticeFormScreenState();
}

class _PracticeFormScreenState extends ConsumerState<PracticeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _managerNameController;
  late TextEditingController _udaRateController;
  late TextEditingController _privatePercentageController;
  late TextEditingController _hygieneFeeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.practice?.name);
    _addressController = TextEditingController(text: widget.practice?.address);
    _emailController =
        TextEditingController(text: widget.practice?.contactEmail);
    _managerNameController =
        TextEditingController(text: widget.practice?.practiceManagerName);
    _udaRateController = TextEditingController(
      text: widget.practice?.defaultUDARate.toString() ?? '0.0',
    );
    _privatePercentageController = TextEditingController(
      text: widget.practice?.defaultPrivatePercentage.toString() ?? '0.0',
    );
    _hygieneFeeController = TextEditingController(
      text: widget.practice?.defaultHygieneFee.toString() ?? '0.0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _managerNameController.dispose();
    _udaRateController.dispose();
    _privatePercentageController.dispose();
    _hygieneFeeController.dispose();
    super.dispose();
  }

  Future<void> _savePractice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final practice = PracticeModel(
        id: widget.practice?.id ?? '',
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        contactEmail: _emailController.text.trim(),
        practiceManagerName: _managerNameController.text.trim(),
        managerEmail: _emailController.text.trim(),
        managerPhone: '',
        udaRate: double.tryParse(_udaRateController.text) ?? 0,
        defaultUDARate: double.tryParse(_udaRateController.text) ?? 0,
        defaultPrivatePercentage:
            double.tryParse(_privatePercentageController.text) ?? 0,
        defaultHygieneFee: double.tryParse(_hygieneFeeController.text) ?? 0,
        createdAt: widget.practice?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.practice == null) {
        await ref.read(practiceServiceProvider).createPractice(practice);
      } else {
        await ref.read(practiceServiceProvider).updatePractice(practice);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save practice: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.practice == null ? 'Add Practice' : 'Edit Practice'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Practice Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a practice name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Contact Email (Optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _managerNameController,
              decoration: const InputDecoration(
                labelText: 'Practice Manager Name (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _udaRateController,
              decoration: const InputDecoration(
                labelText: 'Default UDA Rate',
                border: OutlineInputBorder(),
                prefixText: '£',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a UDA rate';
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
                labelText: 'Default Private Percentage',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a private percentage';
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
            TextFormField(
              controller: _hygieneFeeController,
              decoration: const InputDecoration(
                labelText: 'Default Hygiene Fee',
                border: OutlineInputBorder(),
                prefixText: '£',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a hygiene fee';
                }
                final fee = double.tryParse(value);
                if (fee == null) {
                  return 'Please enter a valid number';
                }
                if (fee < 0) {
                  return 'Fee cannot be negative';
                }
                if (fee > 1000) {
                  return 'Fee seems unusually high. Please verify the amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _savePractice,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.practice == null ? 'Add Practice' : 'Save Changes',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
