import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quote_provider.dart';
import '../../providers/log_provider.dart';
import '../../providers/bug_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteProvider);
    final logState = ref.watch(logProvider);
    final bugState = ref.watch(bugProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FocusFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          Text(
            '${_greeting()}, développeur 👋',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 24),

          // Tip / Quote du jour
          _TipCard(quoteAsync: quoteAsync, ref: ref),

          const SizedBox(height: 24),

          // Stats rapides
          Row(
            children: [
              _StatChip(
                icon: Icons.local_fire_department,
                label: '${logState.streak} jour(s)',
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.edit_note,
                label: '${logState.entries.length} logs',
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.bug_report,
                label: '${bugState.entries.length} bugs',
                color: AppColors.error,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Accès rapide
          Text(
            'Accès rapide',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickAccessButton(
                icon: Icons.menu_book,
                label: 'Références',
                color: const Color(0xFF2563EB),
                onTap: () => context.go('/ref'),
              ),
              const SizedBox(width: 8),
              _QuickAccessButton(
                icon: Icons.edit_note,
                label: 'Journal',
                color: AppColors.success,
                onTap: () => context.go('/log'),
              ),
              const SizedBox(width: 8),
              _QuickAccessButton(
                icon: Icons.bug_report,
                label: 'Bugs',
                color: AppColors.error,
                onTap: () => context.go('/bugs'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Activité récente — Logs
          if (logState.entries.isNotEmpty) ...[
            Text(
              'Derniers apprentissages',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...logState.entries.take(2).map(
                  (e) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.edit_note,
                          color: AppColors.primary),
                      title: Text(
                        e.content.length > 80
                            ? '${e.content.substring(0, 80)}...'
                            : e.content,
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(e.date),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11),
                      ),
                      onTap: () => context.go('/log'),
                    ),
                  ),
                ),
          ],

          // Activité récente — Bugs
          if (bugState.entries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Derniers bugs résolus',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...bugState.entries.take(2).map(
                  (e) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.bug_report,
                          color: AppColors.error),
                      title: Text(
                        e.title,
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        e.technology,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11),
                      ),
                      onTap: () => context.go('/bugs'),
                    ),
                  ),
                ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final AsyncValue quoteAsync;
  final WidgetRef ref;

  const _TipCard({required this.quoteAsync, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: quoteAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Text(
            'Impossible de charger le tip.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          data: (tip) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: AppColors.warning, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Tip du jour',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () => ref.refresh(quoteProvider),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '"${tip.content}"',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                '— ${tip.author}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
