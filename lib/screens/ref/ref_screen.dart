import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/ref_provider.dart';

class RefScreen extends ConsumerStatefulWidget {
  const RefScreen({super.key});

  @override
  ConsumerState<RefScreen> createState() => _RefScreenState();
}

class _RefScreenState extends ConsumerState<RefScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(refProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Références',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(refProvider.notifier).setSearch(v),
              decoration: const InputDecoration(
                hintText: 'Rechercher une techno, un tag...',
                prefixIcon:
                    Icon(Icons.search, color: AppColors.textSecondary),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filtres par technologie
          if (state.technologies.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _TechChip(
                    label: 'Tous',
                    selected: state.selectedTechnology == null,
                    onSelected: () =>
                        ref.read(refProvider.notifier).setTechnology(null),
                  ),
                  ...state.technologies.map(
                    (tech) => _TechChip(
                      label: tech,
                      selected: state.selectedTechnology == tech,
                      onSelected: () =>
                          ref.read(refProvider.notifier).setTechnology(tech),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Liste des cheatsheets
          Expanded(
            child: state.filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune fiche trouvée.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.filtered.length,
                    itemBuilder: (context, i) {
                      final sheet = state.filtered[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            sheet.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Wrap(
                              spacing: 6,
                              children: [
                                _TagBadge(
                                    label: sheet.technology,
                                    color: AppColors.primary),
                                ...sheet.tags
                                    .take(3)
                                    .map((t) => _TagBadge(label: t)),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              sheet.isFavorite
                                  ? Icons.star
                                  : Icons.star_border,
                              color: sheet.isFavorite
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                            ),
                            onPressed: () => ref
                                .read(refProvider.notifier)
                                .toggleFavorite(sheet.id),
                          ),
                          onTap: () =>
                              context.push('/ref/detail/${sheet.id}'),
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

class _TechChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _TechChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TagBadge({required this.label, this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10),
      ),
    );
  }
}
