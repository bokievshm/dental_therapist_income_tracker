import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../../core/providers/help_provider.dart';

class GuideDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> guide;

  const GuideDetailsScreen({
    super.key,
    required this.guide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide['title'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (guide['imageUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  guide['imageUrl'] as String,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              guide['title'] as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              guide['description'] as String,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            MarkdownWidget(
              data: guide['content'] as String,
              config: MarkdownConfig(
                configs: [
                  const PConfig(
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  const H1Config(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const H2Config(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const H3Config(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CodeConfig(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                    backgroundColor: Color(0xFFF5F5F5),
                  ),
                  const BlockquoteConfig(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    backgroundColor: Color(0xFFF5F5F5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (guide['relatedGuides'] != null) ...[
              Text(
                'Related Guides',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _RelatedGuidesList(
                relatedGuideIds: List<String>.from(guide['relatedGuides'] as List),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RelatedGuidesList extends ConsumerWidget {
  final List<String> relatedGuideIds;

  const _RelatedGuidesList({
    required this.relatedGuideIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(guidesProvider);

    return guidesAsync.when(
      data: (guides) {
        final relatedGuides = guides.where(
          (guide) => relatedGuideIds.contains(guide['id'] as String),
        ).toList();

        if (relatedGuides.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: relatedGuides.length,
          itemBuilder: (context, index) {
            final guide = relatedGuides[index];
            return Card(
              child: ListTile(
                title: Text(guide['title'] as String),
                subtitle: Text(guide['description'] as String),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GuideDetailsScreen(guide: guide),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }
} 