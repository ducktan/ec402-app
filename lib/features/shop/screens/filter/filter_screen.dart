import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import '../../controllers/search_controller.dart';

class TFilterScreen extends StatefulWidget {
  const TFilterScreen({super.key});

  @override
  State<TFilterScreen> createState() => _TFilterScreenState();
}

class _TFilterScreenState extends State<TFilterScreen> {
  final controller = SearchPageController.instance;

  String _selectedSort = 'Name';
  int? _selectedCategoryId;
  final TextEditingController _minPriceCtrl = TextEditingController();
  final TextEditingController _maxPriceCtrl = TextEditingController();

  final List<String> _sortOptions = [
    'Name', 'Lowest Price', 'Highest Price', 'Popular', 'Newest', 'Suitable'
  ];

  @override
  void initState() {
    super.initState();

    String currentSort = controller.selectedSort.value;
    if (_sortOptions.contains(currentSort)) {
      _selectedSort = currentSort;
    } else {
      _selectedSort = 'Name';
    }

    _selectedCategoryId = controller.selectedCategoryId.value;
    if (controller.minPrice.text.isNotEmpty) _minPriceCtrl.text = controller.minPrice.text;
    if (controller.maxPrice.text.isNotEmpty) _maxPriceCtrl.text = controller.maxPrice.text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent, // bắt buộc cho bottomSheet
      child: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // BODY
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SORT BY
                    Text(
                      'Sort by',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    DropdownButtonFormField<String>(
                      value: _selectedSort,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: _sortOptions.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedSort = val!);
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // PRICE RANGE
                    Text(
                      'Price Range',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minPriceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min',
                              prefixText: '₫ ',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxPriceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max',
                              prefixText: '₫ ',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // CATEGORY
                    Text(
                      'Category',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Obx(() {
                      if (controller.categories.isEmpty) {
                        return const Text("No categories available");
                      }
                      return Column(
                        children: controller.categories.map((cat) {
                          return RadioListTile<int>(
                            title: Text(cat['name'] ?? ''),
                            value: cat['id'],
                            groupValue: _selectedCategoryId,
                            activeColor: theme.primaryColor,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() => _selectedCategoryId = val);
                            },
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // FOOTER BUTTONS
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              children: [
                // RESET
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSort = 'Name';
                        _selectedCategoryId = null;
                        _minPriceCtrl.clear();
                        _maxPriceCtrl.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),

                // APPLY
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.selectedSort.value = _selectedSort;
                      controller.selectedCategoryId.value = _selectedCategoryId;
                      controller.minPrice.text = _minPriceCtrl.text;
                      controller.maxPrice.text = _maxPriceCtrl.text;

                      controller.search(query: controller.searchTextController.text);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply Filter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
