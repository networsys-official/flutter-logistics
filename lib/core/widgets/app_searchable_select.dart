import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';

class AppSearchableSelect<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final String Function(T)? itemSubtitleBuilder;
  final Function(T?) onChanged;
  final bool isLoading;
  final String? Function(T?)? validator;

  const AppSearchableSelect({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.value,
    this.itemSubtitleBuilder,
    this.isLoading = false,
    this.validator
  });

  @override
  State<AppSearchableSelect<T>> createState() => _AppSearchableSelectState<T>();
}

class _AppSearchableSelectState<T> extends State<AppSearchableSelect<T>> {
  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchSheet<T>(
        title: widget.label,
        hint: widget.hint,
        items: widget.items,
        itemLabelBuilder: widget.itemLabelBuilder,
        itemSubtitleBuilder: widget.itemSubtitleBuilder,
        onSelected: widget.onChanged,
        selectedValue: widget.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
        initialValue: widget.value,
        validator: widget.validator,
        builder: (field) {
          // final selectedLabel = field.value != null
          //     ? widget.itemLabelBuilder(field.value as T)
          //     : null;

          final selectedLabel = widget.value != null
              ? widget.itemLabelBuilder(widget.value as T)
              : null;
          return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        InkWell(
          onTap: widget.isLoading ? null : _showSearchSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLabel ?? widget.hint,
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedLabel != null
                          ? AppColors.neutral900
                          : AppColors.neutral500,
                      fontWeight: selectedLabel != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.neutral500,
                  ),
              ],
            ),
          ),
        ),
      ],
    );}
    );
  }
}

class _SearchSheet<T> extends StatefulWidget {
  final String title;
  final String hint;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final String Function(T)? itemSubtitleBuilder;
  final Function(T?) onSelected;
  final T? selectedValue;

  const _SearchSheet({
    required this.title,
    required this.hint,
    required this.items,
    required this.itemLabelBuilder,
    required this.onSelected,
    this.itemSubtitleBuilder,
    this.selectedValue,
  });

  @override
  State<_SearchSheet<T>> createState() => _SearchSheetState<T>();
}

class _SearchSheetState<T> extends State<_SearchSheet<T>> {
  late List<T> _filteredItems;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        setState(() => _filteredItems = widget.items);
      } else {
        setState(() {
          _filteredItems = widget.items.where((item) {
            final label = widget.itemLabelBuilder(item).toLowerCase();
            final subtitle =
                widget.itemSubtitleBuilder?.call(item).toLowerCase() ?? '';
            return label.contains(query.toLowerCase()) ||
                subtitle.contains(query.toLowerCase());
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.neutral100,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppTextField(
              controller: _searchController,
              hint: widget.hint,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.neutral500,
              ),
              onChanged: _onSearchChanged,
              autoFocus: true,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.neutral100),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item == widget.selectedValue;

                      return ListTile(
                        onTap: () {
                          widget.onSelected(item);
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        title: Text(
                          widget.itemLabelBuilder(item),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.neutral900,
                          ),
                        ),
                        subtitle: widget.itemSubtitleBuilder != null
                            ? Text(
                                widget.itemSubtitleBuilder!(item),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.7)
                                      : AppColors.neutral500,
                                ),
                              )
                            : null,
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.neutral200),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
