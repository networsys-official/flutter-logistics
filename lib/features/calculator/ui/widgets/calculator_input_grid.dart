import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class CalculatorInputGrid extends StatelessWidget {
  const CalculatorInputGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Dimensions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(child: _InputField(label: 'Length', hint: 'Length')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _InputField(label: 'Width', hint: 'width')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(child: _InputField(label: 'Height', hint: 'Height')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _InputField(label: 'Weight', hint: 'Weight')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const _InputField(label: 'Price', hint: 'Price'),
        const SizedBox(height: AppSpacing.md),
        const _DropdownField(
          label: 'Item Type',
          hint: 'Select Item Type',
          items: ['I Phone', 'Laptop', 'Electronics', 'Furniture', 'Clothing'],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _ShippingOptions(),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Calculate'),
          ),
        ),
      ],
    );
  }
}

// ─── SHIPPING OPTIONS (Fixed: uses RadioGroup) ───────────────────

class _ShippingOptions extends StatefulWidget {
  const _ShippingOptions();

  @override
  State<_ShippingOptions> createState() => _ShippingOptionsState();
}

class _ShippingOptionsState extends State<_ShippingOptions> {
  String? selectedOption = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Method',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),


        RadioGroup<String>(
          groupValue: selectedOption,
          onChanged: (val) => setState(() => selectedOption = val),
          child: Row(
            children: [
              _RadioOption(
                label: 'Standard',
                value: 'Standard',
                onTap: () => setState(() => selectedOption = 'Standard'),
              ),
              const SizedBox(width: AppSpacing.lg),
              _RadioOption(
                label: 'Priority',
                value: 'Priority',
                onTap: () => setState(() => selectedOption = 'Priority'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _RadioOption extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Radio<String>(
              value: value,

              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}


class _InputField extends StatelessWidget {
  final String label;
  final String hint;

  const _InputField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}


class _DropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.items,
  });

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          decoration: InputDecoration(
            hintText: widget.hint,
          ),
          items: widget.items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowDown01,
            color: Colors.black,
            size: 20,
          ),
        ),
      ],
    );
  }
}