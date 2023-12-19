import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MyDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                // Atur warna latar belakang sesuai keinginan
                // color: Colors.white,
                // // Atur border sesuai keinginan
                // border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 36,
        ),
      ),
    );
  }
}
