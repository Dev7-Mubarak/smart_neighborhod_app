import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../constants/app_size.dart'; // تأكد من أن هذا المسار صحيح

class CustomDropdownSearchWidget<T> extends StatelessWidget {
  const CustomDropdownSearchWidget({
    super.key,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.selectedItem,
    required this.labelText,
    required this.hintText,
    required this.searchHintText,
    this.validator,
    this.enabled=true
  });

  final List<T> items;
  final String Function(T?) itemAsString;
  final void Function(T?) onChanged;
  final T? selectedItem;
  final String labelText;
  final String hintText;
  final String searchHintText;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(8),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(itemAsString(item)),
            selected: isSelected,
          );
        },
        fit: FlexFit.loose,
      ),
      items: items,
      itemAsString: itemAsString,
      onChanged: onChanged,
      selectedItem: selectedItem,
      validator: validator,
       enabled: enabled,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 2),
          ),
        ),
      ),
    );
  }
}