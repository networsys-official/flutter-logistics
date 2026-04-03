import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logistic_by_strom/app/theme/app_theme.dart';
import 'package:logistic_by_strom/core/models/app_settings.dart';
import 'package:logistic_by_strom/features/settings/presentation/view_models/settings_view_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading && viewModel.settings == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null && viewModel.settings == null) {
          return Center(child: Text(viewModel.errorMessage!));
        }

        final AppSettings settings = viewModel.settings!;
        final textTheme = Theme.of(context).textTheme;

        return ListView(
          padding: const EdgeInsets.all(AppTheme.space3),
          children: [
            Text('App settings', style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Keep long-term preferences in repositories and expose UI-friendly state through feature view models.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.space3),
            Card(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: settings.notificationsEnabled,
                    onChanged: viewModel.setNotificationsEnabled,
                    title: const Text('Dispatch notifications'),
                    subtitle: const Text(
                      'Receive updates for route changes and delivery exceptions.',
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.syncOnCellular,
                    onChanged: viewModel.setSyncOnCellular,
                    title: const Text('Sync on cellular'),
                    subtitle: const Text(
                      'Allow shipment refresh outside Wi-Fi when drivers are mobile.',
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    value: settings.biometricLockEnabled,
                    onChanged: viewModel.setBiometricLockEnabled,
                    title: const Text('Biometric lock'),
                    subtitle: const Text(
                      'Protect the dispatch dashboard behind device authentication.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space3),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Architecture notes', style: textTheme.titleLarge),
                    const SizedBox(height: AppTheme.space2),
                    Text(
                      'Views stay lean. Repositories own data. ChangeNotifier view models handle commands and expose state.',
                      style: textTheme.bodyLarge,
                    ),
                    if (viewModel.isSaving) ...[
                      const SizedBox(height: AppTheme.space3),
                      Text('Saving changes...', style: textTheme.bodyMedium),
                    ],
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: AppTheme.space3),
                      Text(
                        viewModel.errorMessage!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
