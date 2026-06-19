import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/ref_provider.dart';

class RefDetailScreen extends ConsumerWidget {
  final String id;

  const RefDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(refProvider);
    final sheet = state.sheets.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('CheatSheet not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sheet.technology,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              sheet.isFavorite ? Icons.star : Icons.star_border,
              color:
                  sheet.isFavorite ? AppColors.warning : AppColors.textSecondary,
            ),
            onPressed: () =>
                ref.read(refProvider.notifier).toggleFavorite(sheet.id),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: AppColors.textSecondary),
            tooltip: 'Copier le contenu',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: sheet.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contenu copié dans le presse-papiers'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              sheet.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 6,
              children: [
                _Badge(label: sheet.technology, color: AppColors.primary),
                ...sheet.tags.map((t) => _Badge(label: t)),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),

            // Contenu (rendu texte brut avec mise en forme des blocs code)
            _ContentRenderer(content: sheet.content),
          ],
        ),
      ),
    );
  }
}

// Rendu simple du contenu avec mise en évidence des blocs de code
class _ContentRenderer extends StatelessWidget {
  final String content;

  const _ContentRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final widgets = <Widget>[];
    final codeBuffer = StringBuffer();
    bool inCodeBlock = false;

    for (final line in lines) {
      if (line.trimLeft().startsWith('```')) {
        if (inCodeBlock) {
          // Fin du bloc code
          widgets.add(_CodeBlock(code: codeBuffer.toString().trimRight()));
          codeBuffer.clear();
          inCodeBlock = false;
        } else {
          inCodeBlock = true;
        }
      } else if (inCodeBlock) {
        codeBuffer.writeln(line);
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 6),
          child: Text(
            line.substring(3),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ));
      } else {
        widgets.add(Text(
          line,
          style: const TextStyle(color: AppColors.text, height: 1.6),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF010409),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Color(0xFF79C0FF),
          height: 1.5,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}
