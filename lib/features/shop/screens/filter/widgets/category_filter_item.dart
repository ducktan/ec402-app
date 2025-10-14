// path: lib/features/shop/screens/filter/widgets/category_filter_item.dart

import 'package:flutter/material.dart';

class TCategoryFilterItem extends StatefulWidget {
  final String categoryName;
  final List<String> subCategories;
  final String? selectedSubCategory;
  final ValueChanged<String?> onSubCategorySelected;

  const TCategoryFilterItem({
    super.key,
    required this.categoryName,
    required this.subCategories,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
  });

  @override
  State<TCategoryFilterItem> createState() => _TCategoryFilterItemState();
}

class _TCategoryFilterItemState extends State<TCategoryFilterItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.categoryName, style: Theme.of(context).textTheme.titleMedium),
      childrenPadding: const EdgeInsets.only(left: 16.0),
      children: widget.subCategories.map((subCategory) {
        return RadioListTile<String>(
          title: Text(subCategory),
          value: subCategory,
          groupValue: widget.selectedSubCategory,
          onChanged: (value) {
            widget.onSubCategorySelected(value);
          },
          activeColor: const Color(0xFF6C4EFF), // Màu tím như trong hình
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}