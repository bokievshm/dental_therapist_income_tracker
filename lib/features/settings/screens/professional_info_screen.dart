import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_provider.dart';

class ProfessionalInfoScreen extends ConsumerStatefulWidget {
  const ProfessionalInfoScreen({super.key});

  @override
  ConsumerState<ProfessionalInfoScreen> createState() => _ProfessionalInfoScreenState();
}

class _ProfessionalInfoScreenState extends ConsumerState<ProfessionalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gdcController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfessionalData();
  }

  @override
  void dispose() {
    _gdcController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _loadProfessionalData() async {
    final user = ref.read(authProvider).currentUser;
    if (user != null) {
      final userData = await ref.read(userProvider.notifier).getUserData(user.uid);
      _gdcController.text = userData['gdcNumber'] as String? ?? '';
      _specializationController.text = userData['specialization'] as String? ?? '';
      _experienceController.text = userData['yearsOfExperience']?.toString() ?? '';
        }
  }

  Future<void> _updateProfessionalInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authProvider).currentUser;
      if (user != null) {
        await ref.read(userProvider.notifier).updateUserData(
              userId: user.uid,
              data: {
                'gdcNumber': _gdcController.text,
                'specialization': _specializationController.text,
                'yearsOfExperience': int.tryParse(_experienceController.text) ?? 0,
              },
            );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Professional information updated successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update professional information: ${e.toString()}')),
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
        title: const Text('Professional Information'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GDC Number
                    TextFormField(
                      controller: _gdcController,
                      decoration: const InputDecoration(
                        labelText: 'GDC Number',
                        border: OutlineInputBorder(),
                        helperText: 'Enter your General Dental Council registration number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your GDC number';
                        }
                        final gdcRegex = RegExp(r'^\d{6}$');
                        if (!gdcRegex.hasMatch(value)) {
                          return 'Please enter a valid 6-digit GDC number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Specialization
                    TextFormField(
                      controller: _specializationController,
                      decoration: const InputDecoration(
                        labelText: 'Specialization',
                        border: OutlineInputBorder(),
                        helperText: 'Enter your dental specialization or area of expertise',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your specialization';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Years of Experience
                    TextFormField(
                      controller: _experienceController,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience',
                        border: OutlineInputBorder(),
                        helperText: 'Enter your years of experience as a dental therapist',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your years of experience';
                        }
                        final years = int.tryParse(value);
                        if (years == null || years < 0) {
                          return 'Please enter a valid number of years';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfessionalInfo,
                        child: const Text('Update Professional Information'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 