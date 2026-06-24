import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/log_provider.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.warning.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppColors.warning, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${state.streak} jour(s)',
                  style: const TextStyle(
                      color: AppColors.warning, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/log/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(logProvider.notifier).setSearch(v),
              decoration: const InputDecoration(
                hintText: 'Rechercher dans le journal, tags...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Liste
          Expanded(
            child: state.filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit_note,
                            color: AppColors.textSecondary, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          state.searchQuery.isEmpty
                              ? 'Aucun log pour le moment.'
                              : 'Aucun résultat pour "${state.searchQuery}".',
                          style: const TextStyle(
                              color: AppColors.textSecondary),
                        ),
                        if (state.searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Appuie sur + pour noter ce que tu as appris.',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: state.filtered.length,
                    itemBuilder: (context, i) {
                      final entry = state.filtered[i];
                      return Dismissible(
                        key: Key(entry.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: AppColors.error),
                        ),
                        onDismissed: (_) =>
                            ref.read(logProvider.notifier).deleteEntry(entry.id),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 12, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd MMM yyyy · HH:mm')
                                          .format(entry.date),
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.content,
                                  style: const TextStyle(height: 1.5),
                                ),
                                if (entry.tags.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    children: entry.tags
                                        .map((t) => _TagChip(label: t))
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style:
            const TextStyle(color: AppColors.primary, fontSize: 10),
      ),
    );
  }
}
