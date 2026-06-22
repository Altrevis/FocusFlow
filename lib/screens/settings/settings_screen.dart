import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/hive_service.dart';
import '../../providers/theme_provider.dart';
import '../../providers/log_provider.dart';
import '../../providers/bug_provider.dart';
import '../../providers/courses_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _apiKeyController;
  bool _apiKeyVisible = false;

  @override
  void initState() {
    super.initState();
    final savedKey =
        HiveService.settings.get('youtubeApiKey', defaultValue: '') as String;
    _apiKeyController = TextEditingController(text: savedKey);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveApiKey() {
    final key = _apiKeyController.text.trim();
    HiveService.settings.put('youtubeApiKey', key);
    // Recharge le provider courses avec la nouvelle clé
    ref.invalidate(coursesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(key.isEmpty ? 'Clé API supprimée.' : 'Clé API sauvegardée.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final logCount = ref.watch(logProvider).entries.length;
    final bugCount = ref.watch(bugProvider).entries.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Apparence
          _SectionHeader(label: 'Apparence'),
          Card(
            child: SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Interface sombre pour le confort visuel',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // API YouTube
          _SectionHeader(label: 'Cours YouTube Shorts'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clé API YouTube Data v3',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Nécessaire pour charger les Shorts.\nObtiens-la sur console.cloud.google.com',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 11, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _apiKeyController,
                          obscureText: !_apiKeyVisible,
                          decoration: InputDecoration(
                            hintText: 'AIza...',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _apiKeyVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              onPressed: () => setState(
                                  () => _apiKeyVisible = !_apiKeyVisible),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveApiKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: const Text('Sauvegarder'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          _SectionHeader(label: 'Données locales'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage,
                      color: AppColors.textSecondary),
                  title: const Text('Logs enregistrés'),
                  trailing: Text('$logCount',
                      style: const TextStyle(color: AppColors.textSecondary)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report,
                      color: AppColors.textSecondary),
                  title: const Text('Bugs enregistrés'),
                  trailing: Text('$bugCount',
                      style: const TextStyle(color: AppColors.textSecondary)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text('Réinitialiser les données',
                      style: TextStyle(color: AppColors.error)),
                  subtitle: const Text(
                      'Supprime tous les logs et bugs enregistrés',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () => _confirmReset(context, ref),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // À propos
          _SectionHeader(label: 'À propos'),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline,
                      color: AppColors.textSecondary),
                  title: Text('Version'),
                  trailing: Text('1.0.0',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.code, color: AppColors.textSecondary),
                  title: Text('FocusFlow'),
                  subtitle: Text('Le compagnon du développeur au quotidien',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser les données'),
        content: const Text(
          'Tous tes logs et bugs enregistrés seront supprimés. Cette action est irréversible.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HiveService.logs.clear();
      await HiveService.bugs.clear();
      // Recharge les providers
      ref.invalidate(logProvider);
      ref.invalidate(bugProvider);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
