import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final packageInfo = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // App logo and name
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dental Therapist Income Tracker',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version ${packageInfo.version} (${packageInfo.buildNumber})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // App description
              const Text(
                'A comprehensive tool for dental therapists to track their income, '
                'manage NHS courses, and generate invoices.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Links and information
              _AboutSection(
                title: 'Developer',
                children: [
                  _AboutTile(
                    icon: Icons.code,
                    title: 'GitHub',
                    subtitle: 'View source code',
                    onTap: () => _launchUrl('https://github.com/yourusername/dental_therapist_income_tracker'),
                  ),
                  _AboutTile(
                    icon: Icons.email,
                    title: 'Contact',
                    subtitle: 'Send feedback or report issues',
                    onTap: () => _launchUrl('mailto:your.email@example.com'),
                  ),
                ],
              ),
              _AboutSection(
                title: 'Legal',
                children: [
                  _AboutTile(
                    icon: Icons.description,
                    title: 'Privacy Policy',
                    onTap: () => _launchUrl('https://yourwebsite.com/privacy'),
                  ),
                  _AboutTile(
                    icon: Icons.gavel,
                    title: 'Terms of Service',
                    onTap: () => _launchUrl('https://yourwebsite.com/terms'),
                  ),
                  _AboutTile(
                    icon: Icons.copyright,
                    title: 'Licenses',
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'Dental Therapist Income Tracker',
                      applicationVersion: packageInfo.version,
                    ),
                  ),
                ],
              ),
              _AboutSection(
                title: 'Acknowledgments',
                children: [
                  _AboutTile(
                    icon: Icons.favorite,
                    title: 'Flutter',
                    subtitle: 'UI Framework',
                    onTap: () => _launchUrl('https://flutter.dev'),
                  ),
                  _AboutTile(
                    icon: Icons.cloud,
                    title: 'Firebase',
                    subtitle: 'Backend Services',
                    onTap: () => _launchUrl('https://firebase.google.com'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AboutSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _AboutTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 