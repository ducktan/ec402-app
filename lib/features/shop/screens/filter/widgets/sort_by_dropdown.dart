// path: lib/features/shop/screens/filter/widgets/sort_by_dropdown.dart

import 'package:flutter/material.dart';

class TSortByDropdown extends StatefulWidget {
  const TSortByDropdown({super.key});

  @override
  State<TSortByDropdown> createState() => _TSortByDropdownState();
}

class _TSortByDropdownState extends State<TSortByDropdown> {
  final List<String> _options = [
    'Name',
    'Lowest Price',
    'Highest Price',
    'Popular',
    'Newest',
    'Suitable',
  ];

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = _options[0]; // Giá trị mặc định là 'Name'
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      items: _options
          .map((option) => DropdownMenuItem(
        value: option,
        child: Text(option),
      ))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue;
        });
        // TODO: Thêm logic xử lý khi thay đổi lựa chọn
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}