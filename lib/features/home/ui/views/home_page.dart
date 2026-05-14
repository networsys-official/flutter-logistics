import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/providers/reference_data_provider.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_body.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger reference data fetch in background
    ref.watch(referenceDataProvider);

    return const Column(
      children: [
        HomeAppBar(),
        Expanded(child: HomeBody()),
      ],
    );
  }
}
