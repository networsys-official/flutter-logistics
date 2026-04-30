import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/calculator/ui/widgets/calculation_summary_card.dart';
import 'package:logistic_by_strom/features/calculator/ui/widgets/calculator_input_grid.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Invoice'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.white,
        ),
      ),
      body: const SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalculatorInputGrid(),
            SizedBox(height: AppSpacing.xl),
            Divider(color: AppColors.neutral200),
            SizedBox(height: AppSpacing.lg),
            CalculationSummaryCard(),
          ],
        ),
      ),
    );
  }
}
