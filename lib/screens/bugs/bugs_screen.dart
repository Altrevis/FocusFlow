import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/bug_provider.dart';

class BugsScreen extends ConsumerStatefulWidget {
  const BugsScreen({super.key});

  @override
  ConsumerState<BugsScreen> createState() => _BugsScreenState();
}

class _BugsScreenState extends ConsumerState<BugsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bugProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bugs & Solutions',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/bugs/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(bugProvider.notifier).setSearch(v),
              decoration: const InputDecoration(
                hintText: 'Rechercher un bug, une techno, une solution...',
                prefixIcon:
                    Icon(Icons.search, color: AppColors.textSecondary),
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
                        const Icon(Icons.bug_report,
                            color: AppColors.textSecondary, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          state.searchQuery.isEmpty
                              ? 'Aucun bug enregistré.'
                              : 'Aucun résultat pour "${state.searchQuery}".',
                          style: const TextStyle(
                              color: AppColors.textSecondary),
                        ),
                        if (state.searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Appuie sur + pour sauvegarder ta première solution.',
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
                      final bug = state.filtered[i];
                      return Dismissible(
                        key: Key(bug.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              const Icon(Icons.delete, color: AppColors.error),
                        ),
                        onDismissed: (_) => ref
                            .read(bugProvider.notifier)
                            .deleteEntry(bug.id),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 12),
                            title: Text(
                              bug.title,
                              style: const TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  _TechBadge(tech: bug.technology),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(bug.date),
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              if (bug.context.isNotEmpty) ...[
                                _SectionLabel(label: 'Contexte'),
                                Text(bug.context,
                                    style: const TextStyle(
                                        color: AppColors.text,
                                        fontSize: 13,
                                        height: 1.5)),
                                const SizedBox(height: 10),
                              ],
                              _SectionLabel(label: 'Solution'),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color:
                                          AppColors.success.withOpacity(0.3)),
                                ),
                                child: Text(
                                  bug.solution,
                                  style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 13,
                                      height: 1.5),
                                ),
                              ),
                              if (bug.tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: bug.tags
                                      .map((t) => _SmallTag(label: t))
                                      .toList(),
                                ),
                              ],
                            ],
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

class _TechBadge extends StatelessWidget {
  final String tech;

  const _TechBadge({required this.tech});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Text(tech,
          style: const TextStyle(color: AppColors.error, fontSize: 10)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String label;

  const _SmallTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(label,
          style: const TextStyle(color: AppColors.primary, fontSize: 10)),
    );
  }
}
