import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/bug_provider.dart';

class BugAddScreen extends ConsumerStatefulWidget {
  const BugAddScreen({super.key});

  @override
  ConsumerState<BugAddScreen> createState() => _BugAddScreenState();
}

class _BugAddScreenState extends ConsumerState<BugAddScreen> {
  final _titleController = TextEditingController();
  final _contextController = TextEditingController();
  final _solutionController = TextEditingController();
  final _techController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    _solutionController.dispose();
    _techController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String value) {
    final tag = value.trim().toLowerCase();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
    }
    _tagController.clear();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final solution = _solutionController.text.trim();
    final tech = _techController.text.trim();

    if (title.isEmpty || solution.isEmpty || tech.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Titre, technologie et solution sont requis.')),
      );
      return;
    }

    setState(() => _saving = true);
    await ref.read(bugProvider.notifier).addEntry(
          title: title,
          context: _contextController.text.trim(),
          solution: solution,
          tags: _tags,
          technology: tech,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau bug',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Sauvegarder',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(label: 'Titre du bug *'),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Ex: NullPointerException au démarrage...',
              ),
            ),
            const SizedBox(height: 16),

            _FieldLabel(label: 'Technologie *'),
            TextField(
              controller: _techController,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Ex: Flutter, Django, React...',
              ),
            ),
            const SizedBox(height: 16),

            _FieldLabel(label: 'Contexte'),
            TextField(
              controller: _contextController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Décris le contexte du bug...',
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            _FieldLabel(label: 'Solution *'),
            TextField(
              controller: _solutionController,
              maxLines: 4,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Comment as-tu résolu ce bug ?',
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            _FieldLabel(label: 'Tags'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    onSubmitted: _addTag,
                    style: const TextStyle(color: AppColors.text),
                    decoration: const InputDecoration(
                      hintText: 'Ajouter un tag...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  onPressed: () => _addTag(_tagController.text),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _tags
                    .map(
                      (t) => Chip(
                        label: Text(t,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.text)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => setState(() => _tags.remove(t)),
                        backgroundColor: AppColors.card,
                        side: const BorderSide(color: AppColors.border),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
